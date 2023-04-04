

import 'dart:io';

import 'package:do_an/widgets/selectFiles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart'as slideDialog;




class upLoadVideo extends StatefulWidget {
  const upLoadVideo({super.key});

  @override
  State<upLoadVideo> createState() => _upLoadVideoState();
}

class _upLoadVideoState extends State<upLoadVideo> {
  File? file;
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: Column(
        children: [
          Center(
            child: TextButton(
              onPressed: _showDialog,
              child: Text("Upload video"),
              
            ),
            
          ),
          
        ],
      ),
    );
  }

  void _showDialog() {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    slideDialog.showSlideDialog(
      context: this.context,
      child: selectAndUploadFiles(),
      // barrierColor: Colors.white.withOpacity(0.7),
      // pillColor: Colors.red,
      // backgroundColor: Colors.yellow,
    );
  }
}
