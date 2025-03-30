import 'package:flutter/foundation.dart';

@immutable
class BalanceState {
  final double totalBalance;
  final double totalIncome;
  final double totalExpenses;

  const BalanceState({
    this.totalBalance = 0.0,
    this.totalIncome = 0.0,
    this.totalExpenses = 0.0,
  });

  BalanceState copyWith({
    double? totalBalance,
    double? totalIncome,
    double? totalExpenses,
  }) {
    return BalanceState(
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
    );
  }
}
