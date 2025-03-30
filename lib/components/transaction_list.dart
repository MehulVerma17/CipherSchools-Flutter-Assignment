import 'package:expense_tracker/database/database_helper.dart';
import 'package:expense_tracker/providers/balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TransactionList extends ConsumerStatefulWidget {
  const TransactionList({super.key});

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends ConsumerState<TransactionList> {
  List<Map<String, dynamic>> dataList = [];

  // Function to get color based on category
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'travel':
        return Colors.blue;
      case 'shopping':
        return Colors.green;
      case 'entertainment':
        return Colors.purple;
      default:
        return Colors.grey; // Default color
    }
  }

  // Function to get icon based on category
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.fastfood;
      case 'travel':
        return Icons.directions_bus;
      case 'shopping':
        return Icons.shopping_cart;
      case 'entertainment':
        return Icons.movie;
      default:
        return Icons.more_horiz; // Default icon
    }
  }

  Future<void> _fetchExpenses() async {
    List<Map<String, dynamic>> expenseList =
        await DatabaseHelper.getAllExpenses();
    setState(() {
      dataList = expenseList;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _delete(int docId) async {
    await DatabaseHelper.deleteData(docId);
    await _fetchExpenses(); // Refresh list
    ref.read(balanceProvider.notifier).updateBalance(); // Update balance
  }

  String formatTime(String time) {
    try {
      // Parse the stored time string (assuming it's in 'HH:mm' format)
      final DateFormat inputFormat = DateFormat("HH:mm"); // 24-hour format
      final DateFormat outputFormat = DateFormat(
        "hh:mm a",
      ); // 12-hour format with AM/PM

      final DateTime parsedTime = inputFormat.parse(time);
      return outputFormat.format(parsedTime); // Convert to 12-hour AM/PM format
    } catch (e) {
      return time; // Return original in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return dataList.isEmpty
        ? Center(
          child: Text(
            "No transactions",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        )
        : ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            String category = dataList[index]['category'] ?? 'Others';

            return Dismissible(
              key: Key(dataList[index]['id'].toString()),
              direction: DismissDirection.endToStart, // Swipe left to delete
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) async {
                await _delete(dataList[index]['id']);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 3),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF7F9FA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: _getCategoryColor(category),
                      child: Icon(
                        _getCategoryIcon(category),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      dataList[index]['category'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      dataList[index]['description'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: SizedBox(
                      width: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${dataList[index]['type'] == 'income' ? '+' : '-'} ₹${dataList[index]['amount'].toString()}',
                            style: TextStyle(
                              color:
                                  dataList[index]['type'] == 'income'
                                      ? Colors.green
                                      : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis, // Handles overflow
                            maxLines: 1, // Ensures it stays on one line
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${dataList[index]['date'].toString()}\n    ${formatTime(dataList[index]['time'].toString())}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
  }
}
