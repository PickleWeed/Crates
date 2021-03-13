import 'package:flutter/material.dart';
import '../common/theme.dart';

// Custom button for login/register pages
// takes in button text and a function that is performed when button is pressed
class CustomButton extends StatelessWidget {
  final String btnText;
  final Function btnPressed;

  CustomButton({this.btnText, this.btnPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: btnPressed,
        child: SizedBox(
            width: double.infinity,
            child: Center(
                child: Text(btnText,
                    style: TextStyle(
                      color: offWhite,
                    )))),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFED8146)),
        ));
  }

}