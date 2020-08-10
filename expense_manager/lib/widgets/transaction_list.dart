import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints){
          return Column(
            children: <Widget>[
              Text(
                'No transactions yet!',
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(
                // sizedBox are used between widgets for spacing. We can pass height, width or nothing as their childeren
                height: 20,
              ),
              Container(
                  //wrapped the image in container to fix in the specific height wrna column ki height pey ja rha tha
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset('assets/images/waiting.png',
                      fit: BoxFit.cover)), //this widget displays image
            ],
          );
        })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              // itemBuilder is compulsary for ListView.Builder
              return Card(
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                    // leading: CircleAvatar(
                    //   radius: 30,
                    //ye yha se..
                    leading: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape
                              .circle), //yha tk doing same as CircleAvatar
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: FittedBox(
                            //it shrinks the values that exceeds the widget
                            child: Text('\$${transactions[index].amount}')),
                      ),
                    ),
                    title: Text(transactions[index].title,
                        style: Theme.of(context).textTheme.title),
                    subtitle: Text(
                        DateFormat.yMMMd().format(transactions[index].date)),
                    //TRAILING a property to display after the title.
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () => deleteTx(transactions[index].id),
                    )),
              );
            },
            //you cannot provide children to builder here
            itemCount: transactions.length,
          );
  }
}

// return Card(
//                   child: Row(
//                     children: <Widget>[
//                       Container(
//                           margin: EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 15),
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                   color: Theme.of(context).primaryColor,
//                                   width: 2)),
//                           padding: EdgeInsets.all(10),
//                           child: Text(
//                             '\$${transactions[index].amount.toStringAsFixed(2)}', //tx.amount.toString()
//                             // dollar sign esey nhi lga sktey to istrha likha
//                             //to dollar sign bhi ajayega
//                             //.toStringAsFixed(2) gives 2 values uto decimal places
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                                 color: Theme.of(context).primaryColor),
//                           )),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(transactions[index].title,
//                               style: Theme.of(context).textTheme.title),
//                           Text(
//                               DateFormat.yMMMd().format(transactions[
//                                       index] //DateFormat('yyyy-MM-dd') esey bhi likh sktey hn
//                                   .date), //DateFormat.() put a dot before paranthesis to see builtin format function
//                               style: TextStyle(color: Colors.grey))
//                         ],
//                       )
//                     ],
//                   ),
//                 );