// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get language => '中文';

  @override
  String get home => '首页';

  @override
  String get settings => '设置';

  @override
  String get error => '错误';

  @override
  String get loading => '加载中.....';

  @override
  String get darkmode => '深色模式';

  @override
  String get profile => '个人资料';

  @override
  String get nickname => '昵称';

  @override
  String get bio => '简介';

  @override
  String get phone => '电话';

  @override
  String get email => '电子邮件';

  @override
  String get save => '保存';

  @override
  String get changeAvatar => '点击更换头像';

  @override
  String get emailNotEditable => '邮箱只能在手机注册时更改';

  @override
  String get phoneNotEditable => '电话只能在邮箱注册时更改';
}
