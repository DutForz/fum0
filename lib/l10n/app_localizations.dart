import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('kk'),
    Locale('ko'),
    Locale('ru'),
    Locale('uz'),
    Locale('zh'),
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'E N G L I S H '**
  String get language;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'H O M E '**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'S E T T I N G S '**
  String get settings;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'e r r o r  '**
  String get error;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'L O A D I N G .....'**
  String get loading;

  /// No description provided for @darkmode.
  ///
  /// In en, this message translates to:
  /// **'D A R K _ M O D E'**
  String get darkmode;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'P R O F I L E'**
  String get profile;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @changeAvatar.
  ///
  /// In en, this message translates to:
  /// **'Tap to change avatar'**
  String get changeAvatar;

  /// No description provided for @emailNotEditable.
  ///
  /// In en, this message translates to:
  /// **'Email can only be changed for phone registration'**
  String get emailNotEditable;

  /// No description provided for @phoneNotEditable.
  ///
  /// In en, this message translates to:
  /// **'Phone can only be changed for email registration'**
  String get phoneNotEditable;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @notAMember.
  ///
  /// In en, this message translates to:
  /// **'not a member ?'**
  String get notAMember;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register now'**
  String get registerNow;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccount;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @doYouMember.
  ///
  /// In en, this message translates to:
  /// **'Do you a member ?'**
  String get doYouMember;

  /// No description provided for @passwordDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Password don\'t match'**
  String get passwordDontMatch;

  /// No description provided for @editingMessage.
  ///
  /// In en, this message translates to:
  /// **'Editing message'**
  String get editingMessage;

  /// No description provided for @messageCopied.
  ///
  /// In en, this message translates to:
  /// **'Message copied to clipboard'**
  String get messageCopied;

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete message'**
  String get deleteMessage;

  /// No description provided for @deleteMessageConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message?'**
  String get deleteMessageConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @alreadyDefaultTheme.
  ///
  /// In en, this message translates to:
  /// **'Already using default theme'**
  String get alreadyDefaultTheme;

  /// No description provided for @changeChatTheme.
  ///
  /// In en, this message translates to:
  /// **'Change Chat Theme'**
  String get changeChatTheme;

  /// No description provided for @resetTheme.
  ///
  /// In en, this message translates to:
  /// **'Reset Theme'**
  String get resetTheme;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @savedThemes.
  ///
  /// In en, this message translates to:
  /// **'Saved Themes'**
  String get savedThemes;

  /// No description provided for @noSavedThemes.
  ///
  /// In en, this message translates to:
  /// **'No saved themes yet'**
  String get noSavedThemes;

  /// No description provided for @savedThemesHint.
  ///
  /// In en, this message translates to:
  /// **'Create a theme in any chat and it will appear here,\nor go to a chat and customize the theme there.'**
  String get savedThemesHint;

  /// No description provided for @goToChatCreateTheme.
  ///
  /// In en, this message translates to:
  /// **'Go to a chat to create theme'**
  String get goToChatCreateTheme;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @fontLabel.
  ///
  /// In en, this message translates to:
  /// **'Font: '**
  String get fontLabel;

  /// No description provided for @customizeChatTheme.
  ///
  /// In en, this message translates to:
  /// **'Customize Chat Theme'**
  String get customizeChatTheme;

  /// No description provided for @themeName.
  ///
  /// In en, this message translates to:
  /// **'Theme Name'**
  String get themeName;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @backgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Background Color'**
  String get backgroundColor;

  /// No description provided for @yourBubbleColor.
  ///
  /// In en, this message translates to:
  /// **'Your Bubble Color'**
  String get yourBubbleColor;

  /// No description provided for @othersBubbleColor.
  ///
  /// In en, this message translates to:
  /// **'Other\'s Bubble Color'**
  String get othersBubbleColor;

  /// No description provided for @yourTextColor.
  ///
  /// In en, this message translates to:
  /// **'Your Text Color'**
  String get yourTextColor;

  /// No description provided for @othersTextColor.
  ///
  /// In en, this message translates to:
  /// **'Other\'s Text Color'**
  String get othersTextColor;

  /// No description provided for @appBarColor.
  ///
  /// In en, this message translates to:
  /// **'AppBar Color'**
  String get appBarColor;

  /// No description provided for @fontStyle.
  ///
  /// In en, this message translates to:
  /// **'Font Style'**
  String get fontStyle;

  /// No description provided for @applyTheme.
  ///
  /// In en, this message translates to:
  /// **'Apply Theme'**
  String get applyTheme;

  /// No description provided for @customRgb.
  ///
  /// In en, this message translates to:
  /// **'Custom RGB'**
  String get customRgb;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @shonenCustom.
  ///
  /// In en, this message translates to:
  /// **'Shonen (Custom)'**
  String get shonenCustom;

  /// No description provided for @otherUser.
  ///
  /// In en, this message translates to:
  /// **'Other user'**
  String get otherUser;

  /// No description provided for @folders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get folders;

  /// No description provided for @createFolder.
  ///
  /// In en, this message translates to:
  /// **'Create Folder'**
  String get createFolder;

  /// No description provided for @folderName.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get folderName;

  /// No description provided for @addUsersToFolder.
  ///
  /// In en, this message translates to:
  /// **'Add users to folder'**
  String get addUsersToFolder;

  /// No description provided for @noUsersInFolder.
  ///
  /// In en, this message translates to:
  /// **'No users in folder'**
  String get noUsersInFolder;

  /// No description provided for @deleteFolder.
  ///
  /// In en, this message translates to:
  /// **'Delete folder'**
  String get deleteFolder;

  /// No description provided for @deleteFolderConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this folder?'**
  String get deleteFolderConfirm;

  /// No description provided for @folderCreated.
  ///
  /// In en, this message translates to:
  /// **'Folder created'**
  String get folderCreated;

  /// No description provided for @userAddedToFolder.
  ///
  /// In en, this message translates to:
  /// **'User added to folder'**
  String get userAddedToFolder;

  /// No description provided for @userRemovedFromFolder.
  ///
  /// In en, this message translates to:
  /// **'User removed from folder'**
  String get userRemovedFromFolder;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'ja',
    'kk',
    'ko',
    'ru',
    'uz',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'kk':
      return AppLocalizationsKk();
    case 'ko':
      return AppLocalizationsKo();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
