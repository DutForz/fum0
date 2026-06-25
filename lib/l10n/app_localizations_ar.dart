// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get language => 'العربية';

  @override
  String get home => 'الرئيسية';

  @override
  String get settings => 'الإعدادات';

  @override
  String get error => 'خطأ';

  @override
  String get loading => 'جارٍ التحميل.....';

  @override
  String get darkmode => 'الوضع الداكن';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get nickname => 'اللقب';

  @override
  String get bio => 'نبذة عني';

  @override
  String get phone => 'الهاتف';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get save => 'حفظ';

  @override
  String get changeAvatar => 'اضغط لتغيير الصورة الرمزية';

  @override
  String get emailNotEditable =>
      'يمكن تغيير البريد الإلكتروني فقط عند التسجيل بالهاتف';

  @override
  String get phoneNotEditable =>
      'يمكن تغيير الهاتف فقط عند التسجيل بالبريد الإلكتروني';
}
