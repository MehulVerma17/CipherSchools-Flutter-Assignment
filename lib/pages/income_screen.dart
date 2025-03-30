import 'package:expense_tracker/database/database_helper.dart';
import 'package:expense_tracker/pages/home.dart';
import 'package:flutter/material.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({Key? key}) : super(key: key);

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _description = TextEditingController();
  final ValueNotifier<String?> _incCategory = ValueNotifier<String?>(null);
  final TextEditingController _amountController = TextEditingController(
    text: "0",
  );

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Controls how long the message stays
        behavior: SnackBarBehavior.floating, // Makes it float above content
        backgroundColor: Colors.black87, // Customize background color
      ),
    );
  }

  void _saveIncome() async {
    // final desc = _description.text;
    // final category = _expCategory.value ?? "";
    // final amount = double.tryParse(_amountController.text) ?? 0;
    // int insertId = await DatabaseHelper.insertExpense(category, desc, amount,);
    final desc = _description.text.trim();
    final category = _incCategory.value;
    final amount = double.tryParse(_amountController.text) ?? 0;
    final dbHelper = DatabaseHelper();

    if (amount <= 0) {
      _showMessage(context, "Enter a valid amount.");
      return;
    }

    if (category == null || category.isEmpty) {
      _showMessage(context, "Please select a category.");
      return;
    }

    if (desc.isEmpty) {
      _showMessage(context, "Enter a Description.");
      return;
    }

    int insertId = await dbHelper.insertExpense(
      category,
      desc,
      amount,
      'income', // Assuming all are expenses
    );

    if (insertId > 0) {
      // _showMessage("Expense added successfully!", success: true);
      _clearFields();
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
    print(insertId);
  }

  void _clearFields() {
    _description.clear();
    _amountController.text = "0";
    _incCategory.value = null;
  }

  void dispose() {
    _description.dispose();
    _incCategory.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.purple,
      body: Column(
        children: [
          // Top Section (Purple background)
          Container(
            width: screenWidth,
            height: screenHeight * 0.35,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.07),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    const Text(
                      "Income",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                const Text(
                  "How much?",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixText: "₹ ",
                    prefixStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    if (_amountController.text == "0") {
                      _amountController.clear(); // Clears "0" when tapped
                    }
                  },
                ),
              ],
            ),
          ),

          // Bottom Section (White Background)
          Expanded(
            child: Container(
              width: screenWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.03),

                    // Category Dropdown
                    buildDropdown("Category", _incCategory),
                    SizedBox(height: screenHeight * 0.02),

                    // Description Field
                    buildTextField("Description", _description),
                    SizedBox(height: screenHeight * 0.02),

                    // Wallet Dropdown
                    // buildDropdown("Wallet"),
                    // SizedBox(height: screenHeight * 0.05),

                    // Continue Button
                    SizedBox(
                      width: screenWidth,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          _saveIncome();
                        },
                        child: const Text(
                          "Continue",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dropdown Field
  Widget buildDropdown(String title, ValueNotifier<String?> controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ValueListenableBuilder<String?>(
        valueListenable: controller,
        builder: (context, value, child) {
          return DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(border: InputBorder.none),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            items:
                ["Shopping", "Entertainment", "Travel", "Food", "Others"].map((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            onChanged: (val) {
              controller.value = val; // Update selected value
            },
            hint: Text(title, style: const TextStyle(color: Colors.grey)),
          );
        },
      ),
    );
  }

  // Text Input Field
  Widget buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
