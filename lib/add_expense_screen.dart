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
  int _selectedCategoryId = 1;

  // 1. අද දවස මුලින්ම Variable එකකට ගන්නවා
  DateTime _selectedDate = DateTime.now();

  final TextEditingController _noteController = TextEditingController();

  // දිනය ලස්සනට UI එකේ පෙන්වන්න හදාගත්ත function එකක්
  String _getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return "Today, ${months[date.month - 1]} ${date.day}";
    }
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  // 2. Calendar එක open කරන function එක
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        // App එකේ theme එකට ගැලපෙන්න Calendar එකත් Dark/Gold කරනවා
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFFD700), // Gold color buttons/header
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E1E), // Dark background for calendar
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF121212),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // තෝරපු දවස variable එකට දානවා
      });
    }
  }

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
      backgroundColor: const Color(0xFF121212),
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

                  // 3. Date Picker (දැන් InkWell එකකින් click කරන්න පුළුවන් කරලා තියෙන්නේ)
                  InkWell(
                    onTap: () =>
                        _selectDate(context), // Click කරාම calendar එක එනවා
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
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
                            children: [
                              const Text(
                                'DATE',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _getFormattedDate(
                                  _selectedDate,
                                ), // Dynamic දිනය මෙතනට වැටෙනවා
                                style: const TextStyle(
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

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse(
                        'http://localhost:3000/api/expenses',
                      );

                      // Database එකට YYYY-MM-DD විදියට යවන්න හදාගන්නවා
                      String apiFormattedDate =
                          "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

                      try {
                        final response = await http.post(
                          url,
                          headers: {'Content-Type': 'application/json'},
                          body: json.encode({
                            'userId': 2,
                            'categoryId': _selectedCategoryId,
                            'amount': double.parse(_amount),
                            'expenseDate':
                                apiFormattedDate, // <-- 4. පරණ hardcode දවස වෙනුවට ඇත්තම දවස මෙතනින් යනවා
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
