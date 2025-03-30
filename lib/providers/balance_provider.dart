import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import 'balance_state.dart';

class BalanceNotifier extends StateNotifier<BalanceState> {
  BalanceNotifier() : super(const BalanceState()) {
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    double balance = await DatabaseHelper().getTotalBalance();
    double income = await DatabaseHelper.getTotalIncome();
    double expenses = await DatabaseHelper.getTotalExpenses();

    state = BalanceState(
      totalBalance: balance,
      totalIncome: income,
      totalExpenses: expenses,
    );
  }

  Future<void> updateBalance() async {
    _loadBalance();
  }
}

final balanceProvider = StateNotifierProvider<BalanceNotifier, BalanceState>(
  (ref) => BalanceNotifier(),
);
