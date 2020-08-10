import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  String hite;
  MyApp({this.hite});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Height(),
              ),
              Center(
                  child: Container(
                child: Center(
                  child: Text(
                    '$hite',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )),
              Center(
                  child: RaisedButton(
                child: Text("Press me"),
                onPressed: () {
                  print(hite);
                },
              ))
            ],
          ),
        ));
  }
}

class Height extends StatefulWidget {
  Height({Key key}) : super(key: key);
  @override
  _HeightState createState() => _HeightState();
}

class _HeightState extends State<Height> {
  String dropdownValue = 'Height';
  String height;
  String newValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String changedValue) {
        newValue=changedValue;
        setState(() {
          
          height = newValue;
          // MyApp(height: height);
        });

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MyApp(hite: height)));
      },
      items: <String>[
        'Height',
        'Less than 150cm/4ft\'11in',
        '150cm/4ft\'11in - 165cm/5ft\'5in',
        '165cm/5ft\'5in - 175cm/5ft\'8in',
        '175cm/5ft\'8in-185cm/6ft\'0in',
        'Above'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
