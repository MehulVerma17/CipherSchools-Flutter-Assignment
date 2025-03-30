import 'package:expense_tracker/pages/expense_screen.dart';
import 'package:expense_tracker/pages/income_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: screenHeight * 0.11,
          padding: EdgeInsets.only(top: screenHeight * 0.02),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(screenWidth * 0.08),
              topRight: Radius.circular(screenWidth * 0.08),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Color(0xFF7B61FF),
            unselectedItemColor: Colors.grey,
            currentIndex: currentIndex,
            onTap: onTap,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  child: Icon(Icons.home),
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  child: Icon(Icons.swap_horiz),
                ),
                label: "Transaction",
              ),
              BottomNavigationBarItem(
                icon: SizedBox(width: screenWidth * 0.16),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  child: Icon(Icons.pie_chart),
                ),
                label: "Budget",
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  child: Icon(Icons.person),
                ),
                label: "Profile",
              ),
            ],
          ),
        ),

        // Floating Action Button with Modal Bottom Sheet
        Positioned(
          top: -screenHeight * 0.018,
          left: screenWidth / 2 - screenWidth * 0.08,
          child: SizedBox(
            width: screenWidth * 0.16,
            height: screenWidth * 0.16,
            child: FloatingActionButton(
              backgroundColor: Color(0xFF7B61FF),
              elevation: 6,
              shape: const CircleBorder(),
              onPressed: () => _showAddOptions(context), // Show bottom sheet
              child: const Icon(Icons.add, size: 30, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // Function to show bottom sheet with Expense and Income options
  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset('lib/images/expense.svg'),
                ),
                title: const Text("Add Expense"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExpenseScreen(),
                    ),
                  ); // Navigate
                },
              ),
              ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset('lib/images/income.svg'),
                ),
                title: const Text("Add Income"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IncomeScreen(),
                    ),
                  ); // Navigate
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
