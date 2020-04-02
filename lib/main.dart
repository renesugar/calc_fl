import 'package:flutter/material.dart';
import 'calcmodel.dart';

void main() => runApp(MyApp());

// Android and iOS both support auto-scaling the font in widgets so Flutter
// could provide widgets to do this directly.
//
// https://stackoverflow.com/questions/51674962/how-to-make-text-as-big-as-the-width-allows-in-flutter
double calculateAutoscaleFontSize(String text, TextStyle style, double startFontSize, double maxWidth) {
  final textPainter = TextPainter(textDirection: TextDirection.ltr);

  var currentFontSize = startFontSize;

  for (var i = 0; i < 100; i++) {
    final nextFontSize = currentFontSize + 1;
    final nextTextStyle = style.copyWith(fontSize: nextFontSize);
    textPainter.text = TextSpan(text: text, style: nextTextStyle);
    textPainter.layout();
    if (textPainter.width >= maxWidth) {
      break;
    } else {
      currentFontSize = nextFontSize;
      // continue iteration
    }
  }

  return currentFontSize;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
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
        backgroundColor: Colors.black,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Calculator'),
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
  var _value = "0";
  var _calculator = new CalcModel();

  void alert(String val) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Alert"),
          content: new Text(val),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updateDisplay(String val) {
    // This call to setState tells the Flutter framework that something has
    // changed in this State, which causes it to rerun the build method below
    // so that the display can reflect the updated values. If we changed
    // _value without calling setState(), then the build method would not be
    // called again, and so nothing would appear to happen.
    setState(() {
      _value = val;
    });
  }

  void onTapSign() {
    var accumulator = _calculator.getAccumulator(_value);

    if (accumulator == "0") {
      ; // do nothing
    } else if (accumulator == "0.0") {
      ; // do nothing
    } else if (accumulator.startsWith("-")) {
      accumulator = accumulator.substring(1);
    } else {
      accumulator = "-" + accumulator;
    }
    updateDisplay(accumulator);
  }

  void onDigit(String digit) {
    var accumulator = (_calculator.isResult() ? "" : _calculator.getAccumulator(_value));
    _calculator.setResultFalse();

    if (accumulator == "0") {
      accumulator = "" + digit;
    } else {
      accumulator = ("" + accumulator) + digit;
    }
    updateDisplay(accumulator);
  }

  void onDecimal() {
    var accumulator = (_calculator.isResult() ? "0" : _calculator.getAccumulator(_value));
    _calculator.setResultFalse();

    if (accumulator.indexOf(".") == -1) {
      accumulator = ("" + accumulator) + ".";
    }
    updateDisplay(accumulator);
  }

  void onEquals() {
    var accumulator = _calculator.getAccumulator(_value);
    _calculator.calculateResult(accumulator);
    _calculator.setResultTrue();

    var status = _calculator.getStatus();

    if (status != "") {
      updateDisplay("0");
      _calculator.setStatus("");
      alert(status);
    }
    else {
      updateDisplay(_calculator.getResult());
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        color: const Color(0xff575757),
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final text = '$_value';
                final style = TextStyle(
                    textBaseline: TextBaseline.alphabetic,
                    color: Colors.white,
                    backgroundColor: Colors.black,
                    fontFamily: "FontAwesomeSolid",
                    fontWeight: FontWeight.bold,
                    fontSize: 48.0);
                final fontSize = calculateAutoscaleFontSize(text, style, 6.0, constraints.maxWidth);
                return Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: Colors.black,
                          height: 166.0,
                          width: constraints.maxWidth,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              text,
                              textAlign: TextAlign.right,
                              style: style.copyWith(fontSize: fontSize),
                              maxLines: 1,
                            )))
                    );
              },
            ),

            // Row: AC +/- % /

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              _calculator.clearAll();
                              _value = "0";
                              updateDisplay(_value);
                              debugPrint('Pressed AC');
                            },
                            textColor: Colors.white,
                            color: const Color(0xff7b7b7c),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              'AC',
                              style: new TextStyle(
                                  fontFamily: "FontAwesomeSolid",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 38.0
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              onTapSign();
                              debugPrint('Pressed +/-');
                            },
                            textColor: Colors.white,
                            color: const Color(0xff7b7b7c),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              '+/-',
                              style: new TextStyle(
                                  fontFamily: "FontAwesomeSolid",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 38.0
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              _calculator.storeResult(_value);
                              _calculator.onModulo();
                              debugPrint('Pressed %');
                            },
                            textColor: Colors.white,
                            color: const Color(0xff7b7b7c),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              '\u{f295}',
                              style: new TextStyle(
                                  fontFamily: "FontAwesomeSolid",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32.0
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              _calculator.storeResult(_value);
                              _calculator.onDivide();
                              debugPrint('Pressed /');
                            },
                            textColor: Colors.white,
                            color: const Color(0xfffca00b),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              "\u{f529}",
                              style: new TextStyle(
                                fontFamily: "FontAwesomeSolid",
                                fontSize: 32.0,
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
              ],
            ),

            // Row: 7 8 9 x

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              onDigit("7");
                              debugPrint('Pressed 7');
                            },
                            textColor: Colors.white,
                            color: const Color(0xff7b7b7c),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              '7',
                              style: new TextStyle(
                                  fontFamily: "FontAwesomeSolid",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 48.0
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              onDigit("8");
                              debugPrint('Pressed 8');
                            },
                            textColor: Colors.white,
                            color: const Color(0xff7b7b7c),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              '8',
                              style: new TextStyle(
                                  fontFamily: "FontAwesomeSolid",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 48.0
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              onDigit("9");
                              debugPrint('Pressed 9');
                            },
                            textColor: Colors.white,
                            color: const Color(0xff7b7b7c),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              '9',
                              style: new TextStyle(
                                  fontFamily: "FontAwesomeSolid",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 48.0
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              _calculator.storeResult(_value);
                              _calculator.onTimes();
                              debugPrint('Pressed x');
                            },
                            textColor: Colors.white,
                            color: const Color(0xfffca00b),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              "\u{f00d}",
                              style: new TextStyle(
                                fontFamily: "FontAwesomeSolid",
                                fontSize: 32.0,
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
              ],
            ),

            // Row: 4 5 6 -

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              onDigit("4");
                              debugPrint('Pressed 4');
                            },
                            textColor: Colors.white,
                            color: const Color(0xff7b7b7c),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              '4',
                              style: new TextStyle(
                                  fontFamily: "FontAwesomeSolid",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 48.0
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              onDigit("5");
                              debugPrint('Pressed 5');
                            },
                            textColor: Colors.white,
                            color: const Color(0xff7b7b7c),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              '5',
                              style: new TextStyle(
                                  fontFamily: "FontAwesomeSolid",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 48.0
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              onDigit("6");
                              debugPrint('Pressed 6');
                            },
                            textColor: Colors.white,
                            color: const Color(0xff7b7b7c),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              '6',
                              style: new TextStyle(
                                  fontFamily: "FontAwesomeSolid",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 48.0
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              _calculator.storeResult(_value);
                              _calculator.onMinus();
                              debugPrint('Pressed -');
                            },
                            textColor: Colors.white,
                            color: const Color(0xfffca00b),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              "\u{f068}",
                              style: new TextStyle(
                                fontFamily: "FontAwesomeSolid",
                                fontSize: 32.0,
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
              ],
            ),

            // Row: 1 2 3 +

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      color: const Color(0xff575757),
                      width: 80.0,
                      height: 80.0,
                      child: FlatButton(
                        onPressed: () {
                          onDigit("1");
                          debugPrint('Pressed 1');
                        },
                        textColor: Colors.white,
                        color: const Color(0xff7b7b7c),
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.white,
                        highlightColor: Colors.orangeAccent,
                        child: Text(
                          '1',
                          style: new TextStyle(
                              fontFamily: "FontAwesomeSolid",
                              fontWeight: FontWeight.bold,
                              fontSize: 48.0
                          ),
                        ),
                      )
                    )),

                  flex: 1,
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              onDigit("2");
                              debugPrint('Pressed 2');
                            },
                            textColor: Colors.white,
                            color: const Color(0xff7b7b7c),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              '2',
                              style: new TextStyle(
                                  fontFamily: "FontAwesomeSolid",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 48.0
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              onDigit("3");
                              debugPrint('Pressed 3');
                            },
                            textColor: Colors.white,
                            color: const Color(0xff7b7b7c),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              '3',
                              style: new TextStyle(
                                  fontFamily: "FontAwesomeSolid",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 48.0
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              _calculator.storeResult(_value);
                              _calculator.onPlus();
                              debugPrint('Pressed +');
                            },
                            textColor: Colors.white,
                            color: const Color(0xfffca00b),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              "\u{f067}",
                              style: new TextStyle(
                                fontFamily: "FontAwesomeSolid",
                                fontSize: 32.0,
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
              ],
            ),

            // Row: 0 . =

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 162.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              onDigit("0");
                              debugPrint('Pressed 0');
                            },
                            textColor: Colors.white,
                            color: const Color(0xff7b7b7c),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              '0',
                              style: new TextStyle(
                                  fontFamily: "FontAwesomeSolid",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 48.0
                              ),
                            ),
                          )
                      )),

                  flex: 2,
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              onDecimal();
                              debugPrint('Pressed .');
                            },
                            textColor: Colors.white,
                            color: const Color(0xff7b7b7c),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              '.',
                              style: new TextStyle(
                                  fontFamily: "FontAwesomeSolid",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 48.0
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2) ,
                      child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: const Color(0xff575757),
                          width: 80.0,
                          height: 80.0,
                          child: FlatButton(
                            onPressed: () {
                              onEquals();
                              debugPrint('Pressed =');
                            },
                            textColor: Colors.white,
                            color: const Color(0xfffca00b),
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            highlightColor: Colors.orangeAccent,
                            child: Text(
                              "\u{f52c}",
                              style: new TextStyle(
                                fontFamily: "FontAwesomeSolid",
                                fontSize: 32.0,
                              ),
                            ),
                          )
                      )),

                  flex: 1,
                ),
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.

    );
  }
}
