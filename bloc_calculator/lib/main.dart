import 'package:flutter/material.dart';
import 'package:bloc_calculator/calculator_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final TextEditingController _controllerNumberA = TextEditingController();
  final TextEditingController _controllerNumberB = TextEditingController();
  final CalculatorBloc _calculatorBloc = CalculatorBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter BLoC Calculator'),
      ),
      body: BlocProvider<CalculatorBloc>(
        builder: (context) => _calculatorBloc,
        child: BlocListener<CalculatorBloc, CalculatorState>(
          listener: (context, state) {
            if (state is CalculatorFailed) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('${state.error}'),
              ));
            }
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _controllerNumberA,
                    decoration: InputDecoration(
                      labelText: 'Number A',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _controllerNumberB,
                    decoration: InputDecoration(
                      labelText: 'Number B',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text('+'),
                          onPressed: () {
                            calculate(Operation.plus);
                          },
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: RaisedButton(
                          child: Text('-'),
                          onPressed: () {
                            calculate(Operation.minus);
                          },
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: RaisedButton(
                          child: Text('X'),
                          onPressed: () {
                            calculate(Operation.multiple);
                          },
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: RaisedButton(
                          child: Text('/'),
                          onPressed: () {
                            calculate(Operation.divide);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  BlocBuilder<CalculatorBloc, CalculatorState>(
                    builder: (context, state) {
                      if (state is CalculatorInitial) {
                        return Text('Result: -');
                      } else if (state is CalculatorSuccess) {
                        return Text('Result: ${state.result}');
                      } else if (state is CalculatorFailed) {
                        return Text('Error: ${state.error}');
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void calculate(Operation operation) {
    int numberA = int.parse(_controllerNumberA.text.toString());
    int numberB = int.parse(_controllerNumberB.text.toString());
    _calculatorBloc.add(CalculatorEvent(operation, numberA, numberB));
  }
}

/*import 'package:flutter/material.dart';

void main() => runApp(BlocCalculator());

class BlocCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Bloc Calculator',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Bloc Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String output = "0";
  String _output = "0";
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = "";

  buttonPressed(String buttonText) {
    if (buttonText == "CLEAR") {
      _output = "0";
      num1 = 0.0;
      num2 = 0.0;
      operand = "";
    } else if (buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "/" ||
        buttonText == "X") {
      num1 = double.parse(output);
      operand = buttonText;
      _output = "0";
    } else if (buttonText == ".") {
      if (_output.contains(".")) {
        print("Already conatains a decimals");
        return;
      } else {
        _output = _output + buttonText;
      }
    } else if (buttonText == "=") {
      num2 = double.parse(output);

      if (operand == "+") {
        _output = (num1 + num2).toString();
      }
      if (operand == "-") {
        _output = (num1 - num2).toString();
      }
      if (operand == "X") {
        _output = (num1 * num2).toString();
      }
      if (operand == "/") {
        _output = (num1 / num2).toString();
      }

      num1 = 0.0;
      num2 = 0.0;
      operand = "";
    } else {
      _output = _output + buttonText;
    }

    print(_output);

    setState(() {
      output = double.parse(_output).toStringAsFixed(2);
    });
  }

  Widget buildButton(String buttonText) {
    return new Expanded(
      child: new OutlineButton(
        padding: new EdgeInsets.all(24.0),
        child: new Text(
          buttonText,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        //onPressed: () => buttonPressed(buttonText),
        onPressed: () {
          //bloc.eventSink.add(CalculatorEvent)
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Container(
            child: new Column(
          children: <Widget>[
            new Container(
                alignment: Alignment.centerRight,
                padding:
                    new EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
                child: new Text(output,
                    style: new TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                    ))),
            new Expanded(
              child: new Divider(),
            ),
            new Column(children: [
              new Row(children: [
                buildButton("7"),
                buildButton("8"),
                buildButton("9"),
                buildButton("/")
              ]),
              new Row(children: [
                buildButton("4"),
                buildButton("5"),
                buildButton("6"),
                buildButton("X")
              ]),
              new Row(children: [
                buildButton("1"),
                buildButton("2"),
                buildButton("3"),
                buildButton("-")
              ]),
              new Row(children: [
                buildButton("."),
                buildButton("0"),
                buildButton("00"),
                buildButton("+")
              ]),
              new Row(children: [
                buildButton("CLEAR"),
                buildButton("="),
              ])
            ])
          ],
        )));
  }
}*/
