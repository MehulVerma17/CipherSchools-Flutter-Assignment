import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final String icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  String formatAmount(double amount) {
    String text = "₹$amount";
    return text.length > 10 ? "${text.substring(0, 9)}..." : text;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFF6E6), Color(0xFFF8EDD8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'lib/images/${icon}.svg',
                width: 24,
                height: 24,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.024),
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                Text(
                  formatAmount(amount),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
