import 'package:flutter/material.dart';

class ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function onTap;
  ActionIcon(
      {required this.icon, required this.onTap, this.color = Colors.green});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(5)),
          child: Icon(
            icon,
            color: color,
          ),
        ));
  }
}
