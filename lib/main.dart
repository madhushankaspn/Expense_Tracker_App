import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; // Dashboard එක import කරගන්නවා

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner:
          false, 
      theme: ThemeData(primarySwatch: Colors.blue),
      
      home: const DashboardScreen(),
    );
  }
}
