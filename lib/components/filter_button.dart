import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String title;
  final bool isSelected;

  const FilterButton({super.key, required this.title, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // TODO: Implement filtering logic
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          isSelected ? Color(0xFFFCEED4) : Colors.transparent,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Color(0xFFFCAC12) : Color(0xFF7A7E80),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
