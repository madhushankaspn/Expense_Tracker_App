import 'package:flutter/material.dart';
import 'add_expense_screen.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      // අපි ඊළඟට හදන Add Expense screen එක තමයි මුලින්ම පේන්න දාන්නේ
      home: const AddExpenseScreen(),
    );
  }
}
