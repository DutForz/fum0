import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/asn1/primitives/asn1_integer.dart';
import 'package:pointycastle/asn1/primitives/asn1_sequence.dart';
import 'package:pointycastle/export.dart';

class CryptoService {
  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAKeyPair() {
    final keyGen = RSAKeyGenerator()..init(ParametersWithRandom(RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64), _secureRandom()));
    final pair = keyGen.generateKeyPair();
    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(pair.publicKey as RSAPublicKey, pair.privateKey as RSAPrivateKey);
  }
  static String encodeRSAPublicKey(RSAPublicKey key) {
    final topLevel = ASN1Sequence()..add(ASN1Integer(key.modulus!))..add(ASN1Integer(key.exponent!));
    return base64.encode(topLevel.encodedBytes!);
  }
  static RSAPublicKey decodeRSAPublicKey(String encoded) {
    final bytes = base64.decode(encoded);
    final parser = ASN1Parser(Uint8List.fromList(bytes));
    final seq = parser.nextObject() as ASN1Sequence;
    return RSAPublicKey((seq.elements![0] as ASN1Integer).integer!, (seq.elements![1] as ASN1Integer).integer!);
  }
  static String encodeRSAPrivateKey(RSAPrivateKey key) {
    final topLevel = ASN1Sequence()..add(ASN1Integer(key.modulus!))..add(ASN1Integer(key.publicExponent!))..add(ASN1Integer(key.privateExponent!))..add(ASN1Integer(key.p!))..add(ASN1Integer(key.q!));
    return base64.encode(topLevel.encodedBytes!);
  }
  static RSAPrivateKey decodeRSAPrivateKey(String encoded) {
    final bytes = base64.decode(encoded);
    final parser = ASN1Parser(Uint8List.fromList(bytes));
    final seq = parser.nextObject() as ASN1Sequence;
    return RSAPrivateKey((seq.elements![0] as ASN1Integer).integer!, (seq.elements![2] as ASN1Integer).integer!, (seq.elements![3] as ASN1Integer).integer!, (seq.elements![4] as ASN1Integer).integer!);
  }
  static Uint8List generateAESKey() => _secureRandom().nextBytes(32);
  static Uint8List generateIV() => _secureRandom().nextBytes(16);
  static String encryptAESKeyWithRSA(Uint8List aesKey, RSAPublicKey publicKey) {
    final cipher = RSAEngine()..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
    return base64.encode(_processInBlocks(cipher, aesKey, 245));
  }
  static Uint8List decryptAESKeyWithRSA(String encryptedKey, RSAPrivateKey privateKey) {
    final cipher = RSAEngine()..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    return _processInBlocks(cipher, base64.decode(encryptedKey), 256);
  }
  static Map<String, String> encryptMessage(String plainText, Uint8List aesKey) {
    final iv = generateIV();
    final cipher = CBCBlockCipher(AESEngine())..init(true, ParametersWithIV(KeyParameter(aesKey), iv));
    final plainBytes = utf8.encode(plainText);
    final padded = _pad(Uint8List.fromList(plainBytes), 16);
    final encrypted = Uint8List(padded.length);
    var offset = 0;
    while (offset < padded.length) { offset += cipher.processBlock(padded, offset, encrypted, offset); }
    return {'ciphertext': base64.encode(encrypted), 'iv': base64.encode(iv)};
  }
  static String decryptMessage(String ciphertext, String ivBase64, Uint8List aesKey) {
    final encrypted = base64.decode(ciphertext);
    final iv = base64.decode(ivBase64);
    final cipher = CBCBlockCipher(AESEngine())..init(false, ParametersWithIV(KeyParameter(aesKey), iv));
    final decrypted = Uint8List(encrypted.length);
    var offset = 0;
    while (offset < encrypted.length) { offset += cipher.processBlock(encrypted, offset, decrypted, offset); }
    return utf8.decode(_unpad(decrypted));
  }
  static Map<String, dynamic> encryptForRecipient(String plainText, RSAPublicKey recipientPublicKey) {
    final aesKey = generateAESKey();
    final encrypted = encryptMessage(plainText, aesKey);
    final encryptedKey = encryptAESKeyWithRSA(aesKey, recipientPublicKey);
    return {'encryptedKey': encryptedKey, 'ciphertext': encrypted['ciphertext'], 'iv': encrypted['iv']};
  }
  static String decryptFromSender(Map<String, dynamic> encryptedData, RSAPrivateKey myPrivateKey) {
    final aesKey = decryptAESKeyWithRSA(encryptedData['encryptedKey'] as String, myPrivateKey);
    return decryptMessage(encryptedData['ciphertext'] as String, encryptedData['iv'] as String, aesKey);
  }
  static SecureRandom _secureRandom() {
    final secureRandom = FortunaRandom();
    final random = Random.secure();
    secureRandom.seed(KeyParameter(Uint8List.fromList(List<int>.generate(32, (_) => random.nextInt(256)))));
    return secureRandom;
  }
  static Uint8List _processInBlocks(AsymmetricBlockCipher cipher, Uint8List input, int blockSize) {
    final output = BytesBuilder();
    var offset = 0;
    while (offset < input.length) {
      final chunkSize = (input.length - offset) < blockSize ? (input.length - offset) : blockSize;
      output.add(cipher.process(input.sublist(offset, offset + chunkSize)));
      offset += chunkSize;
    }
    return output.toBytes();
  }
  static Uint8List _pad(Uint8List data, int blockSize) {
    final padLength = blockSize - (data.length % blockSize);
    final padded = Uint8List(data.length + padLength);
    padded.setAll(0, data);
    for (var i = data.length; i < padded.length; i++) { padded[i] = padLength; }
    return padded;
  }
  static Uint8List _unpad(Uint8List data) => data.sublist(0, data.length - data[data.length - 1]);
}
