import 'package:geoquiz/module/Question.dart';

class Cheat {

  final Question question;
  bool isCheated = false;

  Cheat(this.question);

  get answer => question.answerTrue;

}
