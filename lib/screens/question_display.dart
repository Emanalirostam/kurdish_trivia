import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kurdish_trivia/models/question.dart';
import 'package:kurdish_trivia/rest.dart';
import 'package:kurdish_trivia/utils.dart';
import 'package:kurdish_trivia/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuestionDisplayPage extends StatefulWidget {
  const QuestionDisplayPage(
      {super.key, required this.categoryId, required this.difficulty});

  final int? categoryId;
  final String? difficulty;

  @override
  State<QuestionDisplayPage> createState() =>
      _QuestionDisplayPageState(categoryId: categoryId, difficulty: difficulty);
}

class _QuestionDisplayPageState extends State<QuestionDisplayPage> {
  _QuestionDisplayPageState(
      {required this.categoryId, required this.difficulty});

  final int? categoryId;
  final String? difficulty;

  List<Question> questions = [];
  int questionsIterator = 0;
  late Future<Question> currentQuestion;
  bool isChoosen = false;
  double questionWidgetHeight = 0;
  int score = 0, totalQuestions = 0;

  @override
  void initState() {
    super.initState();

    currentQuestion =
        getQuestions(1, category: categoryId, difficulty: difficulty).then(
      (value) => value[0],
    );
    refillQuestionsList();
  }

  void refillQuestionsList() async {
    questions =
        await getQuestions(20, category: categoryId, difficulty: difficulty);
  }

  @override
  Widget build(BuildContext context) {
    questionWidgetHeight = MediaQuery.of(context).size.height * 0.6;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.kurdishTrivia),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            questionFutureBuilder(currentQuestion),
            Container(
              margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (questionsIterator >= questions.length) {
                        refillQuestionsList();
                        questionsIterator = 0;
                      }
                      isChoosen = false;
                      currentQuestion = questions.length > questionsIterator
                          ? Future.value(questions[questionsIterator++])
                          : getRandomQuestion();
                    });
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.nextQuestion),
                        Icon(Icons.arrow_forward)
                      ])),
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder<Question> questionFutureBuilder(
          Future<Question> fetchQuestion) =>
      FutureBuilder(
          future: fetchQuestion,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Question question = snapshot.data!;
              var answers = question.answers;
              var cat = question.category;
              var difficulty =
                  translateDifficulty(context, question.difficulty);
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.lightGreen,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5,
                                  color: Colors.lightGreenAccent),
                            ]),
                        child: Text(difficulty,
                            style: TextStyle(color: Colors.primaries[4])),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20, left: 20, top: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.yellow,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5, color: Colors.yellowAccent),
                            ]),
                        child: Text(cat,
                            style: TextStyle(
                                color: Colors.primaries[4],
                                fontSize: cat.length > 25 ? 11 : null)),
                      ),
                    ],
                  ),
                  Container(
                    height: questionWidgetHeight,
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 2,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              padding: EdgeInsets.zero,
                              child: Text(
                                'Score: $score/$totalQuestions',
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(255, 217, 221, 223)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                question.question,
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Expanded(
                              child: Scrollbar(
                                thumbVisibility: true,
                                trackVisibility: true,
                                thickness: 1,
                                child: ListView(children: [
                                  ...answers.map((answer) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 2.0),
                                        child: answerButton(
                                            answer: answer,
                                            onPressed: () {
                                              if (isChoosen) return;
                                              setState(() {
                                                isChoosen = true;
                                                score +=
                                                    answer.isCorrect ? 1 : 0;
                                                totalQuestions++;
                                              });
                                              SchedulerBinding.instance
                                                  .addPostFrameCallback(
                                                      (timeStamp) {
                                                if (answer.isCorrect) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .correct),
                                                  ));
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .incorrect),
                                                  ));
                                                }
                                              });
                                            },
                                            color: isChoosen
                                                ? (answer.isCorrect
                                                    ? Colors.green
                                                    : Colors.red)
                                                : null),
                                      ))
                                ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator());
            }
            return const Text('Error');
          });
}
