import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kurdish_trivia/main.dart';
import 'package:kurdish_trivia/models/category.dart';
import 'package:kurdish_trivia/rest.dart';
import 'package:kurdish_trivia/screens/about.dart';
import 'package:kurdish_trivia/screens/question_display.dart';
import 'package:kurdish_trivia/screens/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kurdish_trivia/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key, required this.categories, required this.difficulties});

  final List<Category> categories;
  final List<String> difficulties;

  @override
  State<HomePage> createState() =>
      _HomePageState(categories: categories, difficulties: difficulties);
}

class _HomePageState extends State<HomePage> {
  _HomePageState({required this.categories, required this.difficulties});

  final List<Category> categories;
  List<String> difficulties;

  late Category selectedCategory;
  late String selectedDifficulty;

  bool loaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      //load things that need the build context here
      ANY_CATEGORY = AppLocalizations.of(context)!.anyCategory;
      ANY_DIFFICULTY = AppLocalizations.of(context)!.anyDifficulty;

      categories.insert(0, Category(id: -1, name: ANY_CATEGORY));
      difficulties.insert(0, ANY_DIFFICULTY);

      selectedCategory = categories[0];
      selectedDifficulty = translateDifficulty(context, difficulties[0]);

      //and translate all difficulties as they are only three ones
      difficulties =
          difficulties.map((e) => translateDifficulty(context, e)).toList();
      loaded = true;
    }

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.kurdishTrivia)),
      drawer: Drawer(
          width: 200,
          child: Container(
              child: ListView(children: [
            ListTile(
                title: Text(AppLocalizations.of(context)!.home),
                onTap: () => Navigator.of(context).pop()),
            ListTile(
                title: Text(AppLocalizations.of(context)!.settings),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ))),
            ListTile(
                title: Text(AppLocalizations.of(context)!.about),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AboutPage(),
                    ))),
          ]))),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
              margin: EdgeInsets.all(20),
              child: Text(AppLocalizations.of(context)!.welcome,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          Container(
              margin: EdgeInsets.all(20),
              child: Text(AppLocalizations.of(context)!.startToTest,
                  style: TextStyle(fontSize: 18, color: Colors.primaries[5]))),
          SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.selectCategory),
          DropdownButton(
            items: categories
                .map<DropdownMenuItem<Category>>((category) => DropdownMenuItem(
                    value: category, child: Text(category.name)))
                .toList(),
            value: selectedCategory,
            onChanged: (Category? category) {
              setState(() {
                selectedCategory = category!;
              });
            },
          ),
          SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.selectDifficulty),
          DropdownButton(
            items: difficulties
                .map<DropdownMenuItem<String>>((difficulty) => DropdownMenuItem(
                    value: difficulty, child: Text(difficulty)))
                .toList(),
            value: selectedDifficulty,
            onChanged: (String? difficulty) {
              setState(() {
                selectedDifficulty = difficulty!;
              });
            },
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                var categoryId =
                    selectedCategory.id == -1 ? null : selectedCategory.id;
                var difficulty = selectedDifficulty == ANY_DIFFICULTY
                    ? null
                    : getDifficulties()[
                        difficulties.indexOf(selectedDifficulty) - 1];
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => QuestionDisplayPage(
                        categoryId: categoryId, difficulty: difficulty)));
              },
              child: Text(AppLocalizations.of(context)!.start))
        ]),
      ),
    );
  }
}
