// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get language => 'Français';

  @override
  String get home => 'Accueil';

  @override
  String get settings => 'Paramètres';

  @override
  String get error => 'erreur';

  @override
  String get loading => 'Chargement.....';

  @override
  String get darkmode => 'Mode sombre';

  @override
  String get profile => 'Profil';

  @override
  String get nickname => 'Surnom';

  @override
  String get bio => 'Bio';

  @override
  String get phone => 'Téléphone';

  @override
  String get email => 'E-mail';

  @override
  String get save => 'Enregistrer';

  @override
  String get changeAvatar => 'Appuyez pour changer l\'avatar';

  @override
  String get emailNotEditable =>
      'L\'e-mail ne peut être modifié que lors d\'une inscription par téléphone';

  @override
  String get phoneNotEditable =>
      'Le téléphone ne peut être modifié que lors d\'une inscription par e-mail';
}
