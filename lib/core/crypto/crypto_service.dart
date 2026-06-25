import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/asn1/primitives/asn1_integer.dart';
import 'package:pointycastle/asn1/primitives/asn1_sequence.dart';
import 'package:pointycastle/export.dart';

/// Сервис для E2E шифрования сообщений.
///
/// Использует гибридную схему:
/// - RSA-2048 для обмена симметричным ключом между пользователями
/// - AES-256 (CBC mode) для шифрования самих сообщений
///
/// Каждый пользователь генерирует свою пару RSA-ключей.
/// При старте чата пользователи обмениваются публичными ключами.
/// Сообщение шифруется AES-ключом, который, в свою очередь,
/// шифруется публичным RSA-ключом получателя.
class CryptoService {
  /// Генерирует новую пару RSA-ключей (2048 бит).
  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAKeyPair() {
    final keyGen = RSAKeyGenerator()
      ..init(
        ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
          _secureRandom(),
        ),
      );
    final pair = keyGen.generateKeyPair();
    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
      pair.publicKey as RSAPublicKey,
      pair.privateKey as RSAPrivateKey,
    );
  }

  /// Сериализует публичный RSA-ключ в Base64 строку для передачи.
  static String encodeRSAPublicKey(RSAPublicKey key) {
    final topLevel = ASN1Sequence()
      ..add(ASN1Integer(key.modulus!))
      ..add(ASN1Integer(key.exponent!));
    return base64.encode(topLevel.encodedBytes!);
  }

  /// Десериализует публичный RSA-ключ из Base64 строки.
  static RSAPublicKey decodeRSAPublicKey(String encoded) {
    final bytes = base64.decode(encoded);
    final parser = ASN1Parser(Uint8List.fromList(bytes));
    final seq = parser.nextObject() as ASN1Sequence;
    final modulus = (seq.elements![0] as ASN1Integer).integer!;
    final exponent = (seq.elements![1] as ASN1Integer).integer!;
    return RSAPublicKey(modulus, exponent);
  }

  /// Сериализует приватный RSA-ключ в Base64 строку для хранения.
  static String encodeRSAPrivateKey(RSAPrivateKey key) {
    final topLevel = ASN1Sequence()
      ..add(ASN1Integer(key.modulus!))
      ..add(ASN1Integer(key.publicExponent!))
      ..add(ASN1Integer(key.privateExponent!))
      ..add(ASN1Integer(key.p!))
      ..add(ASN1Integer(key.q!));
    return base64.encode(topLevel.encodedBytes!);
  }

  /// Десериализует приватный RSA-ключ из Base64 строки.
  static RSAPrivateKey decodeRSAPrivateKey(String encoded) {
    final bytes = base64.decode(encoded);
    final parser = ASN1Parser(Uint8List.fromList(bytes));
    final seq = parser.nextObject() as ASN1Sequence;
    final modulus = (seq.elements![0] as ASN1Integer).integer!;
    final publicExponent = (seq.elements![1] as ASN1Integer).integer!;
    final privateExponent = (seq.elements![2] as ASN1Integer).integer!;
    final p = (seq.elements![3] as ASN1Integer).integer!;
    final q = (seq.elements![4] as ASN1Integer).integer!;
    return RSAPrivateKey(modulus, privateExponent, p, q);
  }

  /// Генерирует случайный AES-256 ключ (32 байта).
  static Uint8List generateAESKey() {
    return _secureRandom().nextBytes(32);
  }

  /// Генерирует случайный IV (16 байт для AES-CBC).
  static Uint8List generateIV() {
    return _secureRandom().nextBytes(16);
  }

  /// Шифрует AES-ключ публичным RSA-ключом получателя.
  static String encryptAESKeyWithRSA(
    Uint8List aesKey,
    RSAPublicKey publicKey,
  ) {
    final cipher = RSAEngine()
      ..init(
        true,
        PublicKeyParameter<RSAPublicKey>(publicKey),
      );
    final encrypted = _processInBlocks(cipher, aesKey, 245);
    return base64.encode(encrypted);
  }

  /// Дешифрует AES-ключ приватным RSA-ключом.
  static Uint8List decryptAESKeyWithRSA(
    String encryptedKey,
    RSAPrivateKey privateKey,
  ) {
    final cipher = RSAEngine()
      ..init(
        false,
        PrivateKeyParameter<RSAPrivateKey>(privateKey),
      );
    final encryptedBytes = base64.decode(encryptedKey);
    return _processInBlocks(cipher, encryptedBytes, 256);
  }

  /// Шифрует текст сообщения AES-256 ключом.
  static Map<String, String> encryptMessage(
    String plainText,
    Uint8List aesKey,
  ) {
    final iv = generateIV();
    final cipher = CBCBlockCipher(AESEngine())
      ..init(
        true,
        ParametersWithIV(KeyParameter(aesKey), iv),
      );

    final plainBytes = utf8.encode(plainText);
    final padded = _pad(Uint8List.fromList(plainBytes), 16);
    final encrypted = Uint8List(padded.length);

    var offset = 0;
    while (offset < padded.length) {
      offset += cipher.processBlock(
        padded,
        offset,
        encrypted,
        offset,
      );
    }

    return {
      'ciphertext': base64.encode(encrypted),
      'iv': base64.encode(iv),
    };
  }

  /// Дешифрует сообщение AES-256 ключом.
  static String decryptMessage(
    String ciphertext,
    String ivBase64,
    Uint8List aesKey,
  ) {
    final encrypted = base64.decode(ciphertext);
    final iv = base64.decode(ivBase64);

    final cipher = CBCBlockCipher(AESEngine())
      ..init(
        false,
        ParametersWithIV(KeyParameter(aesKey), iv),
      );

    final decrypted = Uint8List(encrypted.length);
    var offset = 0;
    while (offset < encrypted.length) {
      offset += cipher.processBlock(
        encrypted,
        offset,
        decrypted,
        offset,
      );
    }

    final unpadded = _unpad(decrypted);
    return utf8.decode(unpadded);
  }

  /// Шифрует сообщение для отправки конкретному получателю.
  static Map<String, dynamic> encryptForRecipient(
    String plainText,
    RSAPublicKey recipientPublicKey,
  ) {
    final aesKey = generateAESKey();
    final encrypted = encryptMessage(plainText, aesKey);
    final encryptedKey = encryptAESKeyWithRSA(aesKey, recipientPublicKey);

    return {
      'encryptedKey': encryptedKey,
      'ciphertext': encrypted['ciphertext'],
      'iv': encrypted['iv'],
    };
  }

  /// Дешифрует сообщение от отправителя.
  static String decryptFromSender(
    Map<String, dynamic> encryptedData,
    RSAPrivateKey myPrivateKey,
  ) {
    final encryptedKey = encryptedData['encryptedKey'] as String;
    final ciphertext = encryptedData['ciphertext'] as String;
    final iv = encryptedData['iv'] as String;

    final aesKey = decryptAESKeyWithRSA(encryptedKey, myPrivateKey);
    return decryptMessage(ciphertext, iv, aesKey);
  }

  // Вспомогательные методы

  static SecureRandom _secureRandom() {
    final secureRandom = FortunaRandom();
    final random = Random.secure();
    final seeds = List<int>.generate(32, (_) => random.nextInt(256));
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  static Uint8List _processInBlocks(
    AsymmetricBlockCipher cipher,
    Uint8List input,
    int blockSize,
  ) {
    final output = BytesBuilder();
    var offset = 0;
    while (offset < input.length) {
      final chunkSize = (input.length - offset) < blockSize
          ? (input.length - offset)
          : blockSize;
      final chunk = input.sublist(offset, offset + chunkSize);
      final processed = cipher.process(chunk);
      output.add(processed);
      offset += chunkSize;
    }
    return output.toBytes();
  }

  /// PKCS7 padding
  static Uint8List _pad(Uint8List data, int blockSize) {
    final padLength = blockSize - (data.length % blockSize);
    final padded = Uint8List(data.length + padLength);
    padded.setAll(0, data);
    for (var i = data.length; i < padded.length; i++) {
      padded[i] = padLength;
    }
    return padded;
  }

  /// PKCS7 unpadding
  static Uint8List _unpad(Uint8List data) {
    final padLength = data[data.length - 1];
    return data.sublist(0, data.length - padLength);
  }
}
