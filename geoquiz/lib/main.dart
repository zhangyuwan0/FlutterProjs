import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoquiz/module/Question.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialApp(
          title: 'GeoQuiz',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: 'GeoQuiz')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Question> _questions = List();

  int _curIndex = 0;
  Question _curQuestion;

  Map<Question, bool> _answerQuestions = HashMap();
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _questions.add(Question("Canberra is the capital of Australia.", true));
    _questions.add(
        Question("The Pacific Ocean is larger than the Atlantic Ocean.", true));
    _questions.add(Question(
        "The Suez Canal connects the Red Sea and the Indian Ocean.", false));
    _questions
        .add(Question("The source of the Nile River is in Egypt.", false));
    _questions.add(Question(
        "The Amazon River is the longest river in the Americas.", true));
    _questions.add(Question(
        "Lake Baikal is the world\'s oldest and deepest freshwater lake.",
        true));
    _curQuestion = _questions.first;
  }

  void _navigationQuestion(bool isNext) {
    _curIndex = _getNextIndex(isNext);
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _curQuestion = _questions.elementAt(_curIndex);
    });
  }

  int _getNextIndex(bool isNext) {
    return ((_curIndex + _questions.length) + (isNext ? 1 : -1)) %
        _questions.length;
  }

  Widget _buildButton(String text, {VoidCallback onPressed}) {
    return RaisedButton(
        onPressed: onPressed ??= null,
        child: Text(
          text,
          style: Theme.of(context).textTheme.button,
        ));
  }

  Function _checkAnswer(bool answer) {
    return () {
      var isCorrect = _curQuestion.answerTrue == answer;
      bool isAnswered = _checkAlreadyAnswered(isCorrect);
      bool isAlreadyComplete = _answerQuestions.length == _questions.length;
      String toastMsg = isAlreadyComplete
          ? "Already completed.Your\'s score is $_score."
          : isAnswered
          ? 'Do not repeat answers'
          : isCorrect ? 'Correct!' : 'Incorrect!';
      // 默认样式的Toast则gravity不生效？已经修复
      Fluttertoast.showToast(
          msg: toastMsg,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: null,
          textColor: null);
    };
  }

  bool _checkAlreadyAnswered(bool isCorrect) {
    if (!_answerQuestions.containsKey(_curQuestion)) {
      _answerQuestions[_curQuestion] = isCorrect;
      _score += isCorrect ? 1 : 0;
      return false;
    }
    return true;
  }

  Function _reset() {
    return () {
      setState(() {
        _curIndex = 0;
        _score = 0;
        _answerQuestions.clear();
        _curQuestion = _questions[_curIndex];
      });

      Fluttertoast.showToast(msg: "Reset Completed!");
    };
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          Widget body;
          if (orientation == Orientation.portrait) {
            body = _buildPortraitLayout();
          } else {
            body = _buildLandscapeLayout();
          }
          return body;
        },
      );
  }

  Widget _buildPortraitLayout() {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      _curQuestion.text,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    _navigationQuestion(true);
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child:
                          _buildButton('true', onPressed: _checkAnswer(true))),
                  Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child:
                          _buildButton('false', onPressed: _checkAnswer(false)))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      width: EdgeInsets.all(24).horizontal,
                      child: RaisedButton(
                        onPressed: () {
                          _navigationQuestion(false);
                        },
                        child: Icon(Icons.arrow_back_ios),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      width: EdgeInsets.all(24).horizontal,
                      child: RaisedButton(
                        onPressed: () {
                          _navigationQuestion(true);
                        },
                        child: Icon(Icons.arrow_forward_ios),
                      )),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.autorenew),
          tooltip: "reset",
          onPressed: _reset(),
        ));
  }

  Widget _buildLandscapeLayout() {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        _curQuestion.text,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () {
                      _navigationQuestion(true);
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: _buildButton('true',
                            onPressed: _checkAnswer(true))),
                    Container(
                        margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: _buildButton('false',
                            onPressed: _checkAnswer(false)))
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 0, 16),
                  width: EdgeInsets.all(24).horizontal,
                  child: RaisedButton(
                    onPressed: () {
                      _navigationQuestion(false);
                    },
                    child: Icon(Icons.arrow_back_ios),
                  )),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 16, 16),
                  width: EdgeInsets.all(24).horizontal,
                  child: RaisedButton(
                    onPressed: () {
                      _navigationQuestion(true);
                    },
                    child: Icon(Icons.arrow_forward_ios),
                  )),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.autorenew),
        backgroundColor: Colors.green,
        tooltip: "reset",
        onPressed: _reset(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
