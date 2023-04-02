import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart'
    as slideDialog;
import 'package:slide_popup_dialog_null_safety/pill_gesture.dart';
import 'package:slide_popup_dialog_null_safety/slide_dialog.dart';
import 'package:raised_buttons/raised_buttons.dart';

class upLoadVideo extends StatefulWidget {
  const upLoadVideo({super.key});

  @override
  State<upLoadVideo> createState() => _upLoadVideoState();
}

class _upLoadVideoState extends State<upLoadVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: _showDialog,
          child: Text("Upload video"),
        ),
      ),
    );
  }

  void _showDialog() {
    slideDialog.showSlideDialog(
      context: context,
      child: Text("Hello World"),
      // barrierColor: Colors.white.withOpacity(0.7),
      // pillColor: Colors.red,
      // backgroundColor: Colors.yellow,
    );
  }
}
