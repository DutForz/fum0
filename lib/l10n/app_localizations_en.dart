// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'E N G L I S H ';

  @override
  String get home => 'H O M E ';

  @override
  String get settings => 'S E T T I N G S ';

  @override
  String get error => 'e r r o r  ';

  @override
  String get loading => 'L O A D I N G .....';

  @override
  String get darkmode => 'D A R K _ M O D E';

  @override
  String get profile => 'P R O F I L E';

  @override
  String get nickname => 'Nickname';

  @override
  String get bio => 'Bio';

  @override
  String get phone => 'Phone';

  @override
  String get email => 'Email';

  @override
  String get save => 'Save';

  @override
  String get changeAvatar => 'Tap to change avatar';

  @override
  String get emailNotEditable =>
      'Email can only be changed for phone registration';

  @override
  String get phoneNotEditable =>
      'Phone can only be changed for email registration';
}
