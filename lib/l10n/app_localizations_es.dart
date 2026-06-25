// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get language => 'Español';

  @override
  String get home => 'Inicio';

  @override
  String get settings => 'Ajustes';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Cargando.....';

  @override
  String get darkmode => 'Modo oscuro';

  @override
  String get profile => 'Perfil';

  @override
  String get nickname => 'Apodo';

  @override
  String get bio => 'Biografía';

  @override
  String get phone => 'Teléfono';

  @override
  String get email => 'Correo electrónico';

  @override
  String get save => 'Guardar';

  @override
  String get changeAvatar => 'Toca para cambiar el avatar';

  @override
  String get emailNotEditable =>
      'El correo solo se puede cambiar con registro por teléfono';

  @override
  String get phoneNotEditable =>
      'El teléfono solo se puede cambiar con registro por correo';
}
