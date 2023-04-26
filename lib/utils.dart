import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late final String ANY_CATEGORY;
late final String ANY_DIFFICULTY;

const String PREFS_DARK_MODE = 'dark_mode';
const String PREFS_LANGUAGE = 'language';

bool isDarkMode = false;
String language = 'ku';
Map<String, String> languagesMap = {
  'en': 'English',
  'ku': 'کوردی',
};

String translateDifficulty(BuildContext context, String difficulty) {
  switch (difficulty) {
    case 'easy':
      return AppLocalizations.of(context)!.easy;
    case 'medium':
      return AppLocalizations.of(context)!.medium;
    case 'hard':
      return AppLocalizations.of(context)!.hard;
    default:
      return difficulty;
  }
}
