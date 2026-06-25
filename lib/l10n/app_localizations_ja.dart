// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get language => '日本語';

  @override
  String get home => 'ホーム';

  @override
  String get settings => '設定';

  @override
  String get error => 'エラー';

  @override
  String get loading => '読み込み中.....';

  @override
  String get darkmode => 'ダークモード';

  @override
  String get profile => 'プロフィール';

  @override
  String get nickname => 'ニックネーム';

  @override
  String get bio => '自己紹介';

  @override
  String get phone => '電話番号';

  @override
  String get email => 'メールアドレス';

  @override
  String get save => '保存';

  @override
  String get changeAvatar => 'タップしてアバターを変更';

  @override
  String get emailNotEditable => 'メールは電話登録の場合のみ変更できます';

  @override
  String get phoneNotEditable => '電話番号はメール登録の場合のみ変更できます';
}
