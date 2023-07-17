import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class validSnackBar extends StatelessWidget {
  final String validMess;
  const validSnackBar({super.key, required this.validMess});

  @override
  Widget build(BuildContext context) {
    return Flushbar(
      messageText: Text(
        validMess,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      duration: Duration(seconds: 5),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(16.0),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: Colors.green,
      icon: Icon(
        Icons.check,
        size: 30,
        color: Colors.white,
      ),
    )..show(context);
  }
}