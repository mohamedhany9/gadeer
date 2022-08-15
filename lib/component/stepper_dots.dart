import 'package:flutter/material.dart';
import 'package:gadeer/helper/app.theme.dart';

class StepperDots extends StatelessWidget {
  final int number;
  StepperDots(this.number);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List<Widget>.generate(3, (index) {
            return _buildDot(index + 1 <= number);
          }).toList()
        ],
      ),
    );
  }

  _buildDot(bool done) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: CircleAvatar(
        radius: 10,
        backgroundColor: done ? AppColors.primary : Colors.grey,
      ),
    );
  }
}
