import 'package:flutter/material.dart';
import 'package:fumo/l10n/app_localizations.dart';

extension BuildContextExtension on BuildContext {
  AppLocalizations get localizations => AppLocalizations.of(this);
}
