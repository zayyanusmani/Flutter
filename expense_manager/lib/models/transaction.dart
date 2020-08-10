import 'package:flutter/foundation.dart'; 
// coud also import material but material internally is based on foundation.dart

class Transaction {
  final String id; 
  final String title;
  final double amount;
  final DateTime date;

  Transaction({
    @required this.id, 
    @required this.title, 
    @required this.amount, 
    @required this.date
    });
}
 