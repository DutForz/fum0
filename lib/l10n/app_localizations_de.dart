// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get language => 'Deutsch';

  @override
  String get home => 'Startseite';

  @override
  String get settings => 'Einstellungen';

  @override
  String get error => 'Fehler';

  @override
  String get loading => 'Lädt.....';

  @override
  String get darkmode => 'Dunkelmodus';

  @override
  String get profile => 'Profil';

  @override
  String get nickname => 'Spitzname';

  @override
  String get bio => 'Bio';

  @override
  String get phone => 'Telefon';

  @override
  String get email => 'E-Mail';

  @override
  String get save => 'Speichern';

  @override
  String get changeAvatar => 'Tippen, um Avatar zu ändern';

  @override
  String get emailNotEditable =>
      'E-Mail kann nur bei Telefonregistrierung geändert werden';

  @override
  String get phoneNotEditable =>
      'Telefon kann nur bei E-Mail-Registrierung geändert werden';
}
