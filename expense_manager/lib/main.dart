import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';

import './widgets/chart.dart';

//SystemChrome is for setting preferences in mobile. It is in flutter/services package
// here we are restricting landscape mode
void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors
              .purple, // primarySwatch app ka primary color theme set krta h
          accentColor: Colors.amber,
          //errorColor: Colors.red, //deault error color hi red hai par agr change krna ho to esey krengey yha sey
          fontFamily: 'QuickSand',
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                      title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    //transaction variable holds the list of Transactions
    // Transaction(
    //     id: 't1',
    //     title: 'Shoes',
    //     amount: 6500,
    //     date: DateTime.now()), //now returns the current time
    // Transaction(
    //     id: 't2',
    //     title: 'Groceries',
    //     amount: 47000,
    //     date: DateTime.now())
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      //.where returns an iterable not a list that's why convert to list
      return tx.date.isAfter(
        // ye is date k baad wali date
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList(); //where allows to run a function on a list and if that function returns
    //true the item is kept in the newly returned list otherwise it is not added
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: chosenDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          // here you return the widget you want to show
          return GestureDetector(
            // without Gesture detector widget's on tap to null, whenever you'd press the ModalWindow it would go back down
            onTap: () {},
            child: NewTransactions(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        }); // the builder function should be inside the ModalBottomSheet
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        //idhr transaction pass kra rhey hn tx sey
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation ==
        Orientation
            .landscape; //it is checking if the mob is in landscape or not and returnung bool
    // we have done this only landscape shit for landscape mode only...potrait me to widgets as usual dikhengi
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Expense Tracker',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize
                  .min, // Ye isliye rakha h q k row ka size infinte hta h wo screen sey bahar chali jati h aur trailing child show nhi krti
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            // idhar final k baad preferred size likh kr explicitly btatya h k CupertinoNavigationBar is implementing PreferredSize widget
            title: Text('Expense Tracker'),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.redAccent,
                ),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );
    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize
                    .height - // this to subtract appBar's height from the total height
                mediaQuery.padding
                    .top) * //mediaQuery.padding.top this to subtract the status bar from the scaffold hieght
            0.7,
        child: TransactionList(
          _userTransactions,
          _deleteTransaction,
        ));

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                // this is an if statement..(check your flutter notes for a ss) ..it checks if this condition is true only then the widget will be added to screen
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Show Chart'),
                  Switch(
                    activeColor: Theme.of(context)
                        .accentColor, //this gives the switch its color wrna default color ayega
                    value: true,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  ),
                ],
              ),
            if (!isLandscape)
              Container(
                  //agar _showChart tru ho to ye show kro warna neechey wala container
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3,
                  child: Chart(_recentTransactions)),
            if (!isLandscape) txListWidget,
            if (isLandscape)
              _showChart
                  ? Container(
                      //agar _showChart tru ho to ye show kro warna neechey wala container
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  : txListWidget
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            //Platform.isIOS returns bool..true if platform is ios
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
