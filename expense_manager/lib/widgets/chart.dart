import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import '../widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      // 7 for 7 days of week and index is for every day from 0 to upto 6
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList(); // q k list me today first arha tha aur last weekday end me 
    //                       to list ko revere krdiya taa k today end me ajaye
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    }); //fold allows us to change a list to another type with a certain logic
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Container(
          padding:EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceAround, // to set the bars to fill in the widget
            children: groupedTransactionValues.map((data) {
              return Flexible( // to keep the huge amount in the limits to not exceed out so wrap chartbar in flexible
                //flex: 1, //with flex and the values you assigned there  you can distibute the available little space  in a row or column
                fit: FlexFit.tight, // with tight we force it to use it's available space
                child: ChartBar(
                    data['day'],
                    data['amount'],
                    totalSpending == 0.0
                        ? 0.0
                        : (data['amount'] as double) / totalSpending),
              );
            }).toList(),
          ),
      ),
    );
  }
}
//Text('${data['day']}: ${data['amount']}'); = Text(data['day'+': '+data['amount'].toString()]);
