import 'dart:io';
import 'package:do_an/pages/gamePage.dart';
import 'package:do_an/pages/likedVideoPage.dart';
import 'package:do_an/pages/listVideoPage.dart';
import 'package:do_an/pages/moviePage.dart';
import 'package:do_an/pages/searchPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an/models/infoVideo.dart';
import 'package:do_an/pages/signInPage.dart';
import 'package:do_an/models/getUserData.dart';
import 'package:do_an/values/app_assets.dart';
import 'package:do_an/widgets/videoCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart'
    as slideDialog;

import '../widgets/selectFiles.dart';
import 'package:do_an/pages/musicPage.dart';

class MyHomePage extends StatefulWidget {
  final UserData users;
  final String userId;
  const MyHomePage({super.key, required this.users, required this.userId});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _selectedIndex;
  File? file;
  UserData? currentUser;
  String? userId;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //UserData _userData = UserData.empty();
  bool _isLoggedIn = false;

  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
    //UserData? currentUser = UserData.getCurrentUser();
    userId = widget.userId;
    currentUser = widget.users;
    if (currentUser?.username != null) {
      setState(() {
        //_userData = currentUser;
        _isLoggedIn = true;
      });
    } else {
      setState(() {
        //_userData = UserData.empty();
        _isLoggedIn = false;
      });
    }
  }

  void _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      currentUser = null;
      userId = null;
      _isLoggedIn = false;
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = [
      listVideo(
        users: currentUser,
        userId: userId,
      ),
      Text(''),
      likedVideo(),
    ];
    return Scaffold(
      appBar: AppBar(
        // title: Center(child: Text(widget.title)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => searchPage(
                            users: widget.users,
                          )),
                );
              },
              icon: const Icon(Icons.search)),
          SizedBox(
            child: (widget.users.username != null && _isLoggedIn)
                ? Center(
                    child: Text(
                    widget.users.username!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ))
                : TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // Điều hướng qua Login
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => signInPage()),
                      );
                    },
                    child: const Text('Login'),
                  ),
          ),
          TextButton(
            onPressed: () {
              _handleLogout();
            },
            child: Text('Logout'),
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
            ),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: ''),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.indigo,
                ),
                onPressed: () {
                  if (_isLoggedIn) {
                    _showDialog();
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => signInPage()));
                  }
                },
              ),
              label: ''),
          const BottomNavigationBarItem(
              icon: Icon(Icons.library_add_outlined), label: ''),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _showDialog() {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    slideDialog.showSlideDialog(
      context: this.context,
      child: selectAndUploadFiles(
        users: widget.users,
        userId: widget.userId,
      ),
      // barrierColor: Colors.white.withOpacity(0.7),
      // pillColor: Colors.red,
      // backgroundColor: Colors.yellow,
    );
  }
}
