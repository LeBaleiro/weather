import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final IconData icon;
  final Function onTap;

  CircularButton({
    @required this.icon,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFD76591),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFE4E5E6),
                blurRadius: 10,
              )
            ]),
        child: Icon(
          icon,
          size: 25,
          color: Color(0xFFE4E5E6),
        ),
      ),
    );
  }
}
