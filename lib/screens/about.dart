import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.about)),
      body: Center(
        child: Column(children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(AppLocalizations.of(context)!.aboutText,
                style: TextStyle(fontSize: 20)),
          )
        ]),
      ),
    );
  }
}
