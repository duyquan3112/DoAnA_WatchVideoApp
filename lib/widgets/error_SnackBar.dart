import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class errorSnackBar extends StatelessWidget {
  final String errMess;
  const errorSnackBar({super.key, required this.errMess});

  @override
  Widget build(BuildContext context) {
    return Flushbar(
      messageText: Text(
        errMess,
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
      backgroundColor: Colors.red,
      icon: Icon(
        Icons.error_outline,
        size: 30,
        color: Colors.white,
      ),
    )..show(context);
  }
}