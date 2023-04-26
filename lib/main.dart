import 'package:flutter/material.dart';
import 'package:flutter_kurdish_localization/flutter_kurdish_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kurdish_trivia/models/category.dart';
import 'package:kurdish_trivia/rest.dart';
import 'package:kurdish_trivia/screens/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kurdish_trivia/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Category> categories = [];
List<String> difficulties = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //let's load the categories here
  categories = await getCategories();
  difficulties = getDifficulties();

  //load the preferences here
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(PREFS_DARK_MODE)) {
    isDarkMode = prefs.getBool(PREFS_DARK_MODE)!;
  } else {
    prefs.setBool(PREFS_DARK_MODE, isDarkMode);
  }

  if (prefs.containsKey(PREFS_LANGUAGE)) {
    language = prefs.getString(PREFS_LANGUAGE)!;
  } else {
    prefs.setString(PREFS_LANGUAGE, language);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kurdish Trivia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: [
        AppLocalizations.delegate, // Add this line
        KurdishMaterialLocalizations.delegate,
        KurdishCupertinoLocalizations.delegate,
        KurdishWidgetLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('ku'),
      ],
      locale: Locale(language),
      home: HomePage(categories: categories, difficulties: difficulties),
    );
  }
}
