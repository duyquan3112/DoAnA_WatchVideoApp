import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an/models/infoVideo.dart';
import 'package:do_an/pages/listVideoPage.dart';
import 'package:do_an/widgets/editVideo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart'
    as slideDialog;

import '../models/getUserData.dart';
import '../widgets/deleteVideo.dart';
import '../widgets/editVideo.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage(
      {super.key,
      required this.info,
      required this.user,
      required this.isLogin});
  final infoVideo info;
  final UserData? user;
  final bool isLogin;
  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  build(BuildContext context) {
    final user1 = widget.user;
    final isLogin = widget.isLogin;
    final docid = user1?.docId;
    //QuerySnapshot vidbelongtodocid = await firestore.collection('videos').where
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 200, 0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {},
                    iconSize: 40,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.alarm),
                  onPressed: () {},
                  alignment: Alignment.center,
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                  alignment: Alignment.center,
                  iconSize: 40,
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user1?.avatarUrl as String),
                      backgroundColor: Colors.red,
                    ),
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '${user1?.username}',
                      style: TextStyle(fontSize: 30),
                    )
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(width: 4),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () {
                    _showDialog();
                  },
                  child: Text("Edit video"),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    // padding: EdgeInsets.fromLTRB(0, 20, 0, 20),

                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(width: 4),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: deleteVideo(
                  info: widget.info,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.purpleAccent,
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () => print('chang to manage profile page'),
                  child: Text('Manage Profile'))
            ],
          ),
        ],
      ),
    );
  }

  void _showDialog() {
    slideDialog.showSlideDialog(
      context: this.context,
      child: editVideo(
        info: widget.info,
      ),
    );
  }
}
