import 'package:expense_tracker/components/filter_button.dart';
import 'package:expense_tracker/components/summary_card.dart';
import 'package:expense_tracker/components/transaction_list.dart';
import 'package:expense_tracker/pages/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/components/custom_bottom_nav.dart';
import 'package:expense_tracker/providers/balance_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(balanceProvider.notifier).updateBalance());
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 1) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const ExpenseScreen()),
      // );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final balanceState = ref.watch(balanceProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Gradient Background for Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: 10,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFF6E6), Color(0x00F8EDD8)],
                stops: [0.0956, 1.0],
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.045),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2), // Border padding
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.purple, // Border color
                          width: 2, // Border thickness
                        ),
                      ),
                      child: StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          final user = snapshot.data;

                          return CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                user?.photoURL != null &&
                                        user!.photoURL!.isNotEmpty
                                    ? NetworkImage(user.photoURL!)
                                    : const AssetImage(
                                      'lib/images/default_profile.png',
                                    ),
                          );
                        },
                      ),
                    ),

                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF7B61FF),
                      ),
                      label: const Text(
                        "October",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color.fromARGB(255, 225, 222, 222),
                          width: 0.6,
                        ), // Border
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            20,
                          ), // Rounded corners
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ), // Adjusted padding
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.notifications, color: Color(0xFF7B61FF)),
                  ],
                ),

                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Account Balance",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown, // Shrinks text if needed
                    child: Text(
                      "₹${balanceState.totalBalance}",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SummaryCard(
                      title: "Income",
                      amount: balanceState.totalIncome,
                      color: Color(0xFF2AB784),
                      icon: "income",
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.016),
                    SummaryCard(
                      title: "Expenses",
                      amount: balanceState.totalExpenses,
                      color: Color(0xFFFD5662),
                      icon: "expense",
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // White Background Content
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilterButton(title: "Today", isSelected: true),
                      FilterButton(title: "Week"),
                      FilterButton(title: "Month"),
                      FilterButton(title: "Year"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Recent Transactions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(
                            0xFFF3EEFF,
                          ), // Background color
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ), // Adjust padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              24,
                            ), // Optional: Rounded corners
                          ),
                        ),
                        child: const Text(
                          "See All",
                          style: TextStyle(color: Color(0xFF7B61FF)),
                        ),
                      ),
                    ],
                  ),

                  Flexible(
                    child: TransactionList(),
                  ), // Ensures it takes remaining space
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}
