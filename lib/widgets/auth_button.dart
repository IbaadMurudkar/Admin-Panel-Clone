import 'package:admin_panel/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton(
      {Key? key,
      required this.fct,
      required this.buttonText,
      this.primary = Colors.white38})
      : super(key: key);

  final Function fct;
  final String buttonText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: primary,
          ),
          onPressed: () {
            fct();
          },
          child:
              TextWidget(text: buttonText, color: Colors.white, textSize: 18)),
    );
  }
}
