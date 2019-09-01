import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoquiz/module/CheatModule.dart';

class CheatPage extends StatefulWidget {
  static const String ROUTE_NAME = "cheat_page";

  @override
  State<StatefulWidget> createState() => _CheatPageState();

}

class _CheatPageState extends State<CheatPage> {

  Cheat _cheat;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showAnswer() {
    _cheat.isCheated = true;
    /// Snack Bar所用的context的层级必须小于Scaffold所在的层级，否则会报
    /// Scaffold.of() called with a context that does not contain a Scaffold.
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("This question's answer is : ${_cheat.answer}"),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {
          _backToMainPage(_scaffoldKey.currentContext);
        },
      ),
    ));

//    Fluttertoast.showToast(msg: _cheat.answer ? "true" : "false");
  }

  void _backToMainPage(BuildContext context) {
    Navigator.pop(context, _cheat);
  }

  @override
  void dispose() {
    super.dispose();
    // 避免用户直接按back键返回上一界面，导致回传参数方法未调用
    _backToMainPage(_scaffoldKey.currentContext);
  }

  @override
  Widget build(BuildContext context) {
    _cheat = ModalRoute.of(context).settings.arguments as Cheat;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            _backToMainPage(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Are you sure want do this?"),
            Container(
              margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
              child: RaisedButton(
                child: Text("SHOW ANSWER"),
                onPressed: () {

                  _showAnswer();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

