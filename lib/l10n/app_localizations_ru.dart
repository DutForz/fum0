// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get language => 'Русский';

  @override
  String get home => 'Домашняя страница';

  @override
  String get settings => 'Настройки';

  @override
  String get error => 'ошибка';

  @override
  String get loading => 'Загрузка.....';

  @override
  String get darkmode => 'Тёмный режим';

  @override
  String get profile => 'Профиль';

  @override
  String get nickname => 'Никнейм';

  @override
  String get bio => 'О себе';

  @override
  String get phone => 'Телефон';

  @override
  String get email => 'Email';

  @override
  String get save => 'Сохранить';

  @override
  String get changeAvatar => 'Нажмите, чтобы сменить аватар';

  @override
  String get emailNotEditable =>
      'Email можно изменить только при регистрации по телефону';

  @override
  String get phoneNotEditable =>
      'Телефон можно изменить только при регистрации по email';
}
