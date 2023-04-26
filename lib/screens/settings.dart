import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kurdish_trivia/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = isDarkMode;
  String currentLanguage = language;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: ListView(children: [
        Container(
            child: ListTile(
                title: Text(AppLocalizations.of(context)!.darkMode),
                trailing: Switch(
                    value: darkMode,
                    onChanged: (value) {
                      setState(() {
                        darkMode = value;
                      });
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setBool(PREFS_DARK_MODE, value);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .restartAppToApply)));
                    }))),
        Container(
            child: ListTile(
                title: Text(AppLocalizations.of(context)!.language),
                trailing: DropdownButton<String>(
                    value: currentLanguage,
                    items: languagesMap.keys.map((String key) {
                      return DropdownMenuItem<String>(
                          value: key, child: Text(languagesMap[key]!));
                    }).toList(),
                    onChanged: (key) {
                      setState(() {
                        currentLanguage = key!;
                      });
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setString(PREFS_LANGUAGE, key!);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .restartAppToApply)));
                    })))
      ]),
    );
  }
}
