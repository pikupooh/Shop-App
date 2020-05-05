import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final Function onTap;
  final Color textColor;
  final Color iconColor;
  final String text;
  final IconData icon;
  final Color buttonColor;
  Buttons(
      {this.onTap,
      this.buttonColor,
      this.text,
      this.icon,
      this.textColor,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
              color: buttonColor, borderRadius: BorderRadius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 19),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(text,
                    style: TextStyle(
                        color: textColor ?? Colors.white, fontSize: 20)),
                icon != null
                    ? SizedBox(
                        width: 5,
                      )
                    : SizedBox(),
                Icon(
                  icon,
                  color: iconColor ?? Colors.white,
                  size: 20,
                )
              ],
            ),
          ),
        ),
        onTap: onTap);
  }
}
