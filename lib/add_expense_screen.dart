import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String _amount = "0.00";

  // මෙන්න අපි හදාගත්ත අලුත් Variable එක (මුලින්ම Food තෝරලා තියෙන්න 1 දෙනවා)
  int _selectedCategoryId = 1;

  final TextEditingController _noteController = TextEditingController();

  // Number pad එකේ බොත්තම් ඔබද්දී amount එක හැදෙන විදිය
  void _onNumPadTap(String value) {
    setState(() {
      if (_amount == "0.00") {
        if (value != "." && value != "backspace") {
          _amount = value;
        }
      } else if (value == "backspace") {
        if (_amount.length > 1) {
          _amount = _amount.substring(0, _amount.length - 1);
        } else {
          _amount = "0.00";
        }
      } else {
        _amount += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'CANCEL',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: const Text(
          'NEW EXPENSE',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Amount Section
                  const Center(
                    child: Text(
                      'AMOUNT',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '\$ ',
                          style: TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _amount,
                          style: const TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Category Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Category',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'View all',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Category Icons (ID එකත් එක්ක දෙනවා)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategoryIcon(Icons.restaurant, 'FOOD', 1),
                      _buildCategoryIcon(Icons.directions_car, 'TRANSPORT', 2),
                      _buildCategoryIcon(Icons.home, 'RENT', 8),
                      _buildCategoryIcon(Icons.shopping_bag, 'SHOPPING', 6),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Date Picker
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Color(0xFFFFD700),
                          size: 20,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'DATE',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Today, Oct 24',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white54,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Note Section
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: TextField(
                      controller: _noteController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'NOTE',
                        labelStyle: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Add a memo...',
                        hintStyle: TextStyle(
                          color: Colors.white38,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Custom Number Pad & Save Button Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: const Color(0xFF121212),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white10, width: 0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      _buildNumPadRow(['1', '2', '3']),
                      _buildNumPadRow(['4', '5', '6']),
                      _buildNumPadRow(['7', '8', '9']),
                      _buildNumPadRow(['.', '0', 'backspace']),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse(
                        'http://localhost:3000/api/expenses',
                      );

                      try {
                        final response = await http.post(
                          url,
                          headers: {'Content-Type': 'application/json'},
                          body: json.encode({
                            'userId': 2,
                            'categoryId':
                                _selectedCategoryId, // <-- හරි Category ID එක මෙතනින් යනවා
                            'amount': double.parse(_amount),
                            'expenseDate': '2026-05-19',
                            'description': _noteController.text.isEmpty
                                ? 'Flutter App Expense'
                                : _noteController.text,
                          }),
                        );

                        if (response.statusCode == 201) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Expense Saved to Database successfully!',
                              ),
                            ),
                          );
                          // Save උනාට පස්සේ Dashboard එකට ගානත් අරන් යනවා
                          Navigator.pop(context, double.parse(_amount));
                        } else {
                          print('Failed: ${response.body}');
                        }
                      } catch (e) {
                        print('Error saving expense: $e');
                      }
                    },
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'SAVE EXPENSE',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2EBC84),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Category Icon එක හදන widget එක (ID එකෙන් වැඩ කරන විදියට හැදුවා)
  Widget _buildCategoryIcon(IconData icon, String label, int id) {
    bool isSelected = _selectedCategoryId == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = id;
        });
      },
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFFFD700) : Colors.white54,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFFFD700) : Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Number Pad එකේ පේළි හදන widget එක
  Widget _buildNumPadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        return Expanded(
          child: InkWell(
            onTap: () => _onNumPadTap(key),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white10, width: 0.5),
              ),
              alignment: Alignment.center,
              child: key == 'backspace'
                  ? const Icon(
                      Icons.backspace_outlined,
                      color: Colors.white54,
                      size: 20,
                    )
                  : Text(
                      key,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
