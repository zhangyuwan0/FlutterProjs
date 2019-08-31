class Question {

  String _text;
  bool _answerTrue;

  Question(this._text,this._answerTrue);

  bool get answerTrue => _answerTrue;

  set answerTrue(bool value) {
    _answerTrue = value;
  }

  String get text => _text;

  set text(String value) {
    _text = value;
  }


}