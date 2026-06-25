// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get language => '한국어';

  @override
  String get home => '홈';

  @override
  String get settings => '설정';

  @override
  String get error => '오류';

  @override
  String get loading => '로딩 중.....';

  @override
  String get darkmode => '다크 모드';

  @override
  String get profile => '프로필';

  @override
  String get nickname => '닉네임';

  @override
  String get bio => '소개';

  @override
  String get phone => '전화번호';

  @override
  String get email => '이메일';

  @override
  String get save => '저장';

  @override
  String get changeAvatar => '탭하여 아바타 변경';

  @override
  String get emailNotEditable => '이메일은 전화 등록 시에만 변경 가능합니다';

  @override
  String get phoneNotEditable => '전화번호는 이메일 등록 시에만 변경 가능합니다';
}
