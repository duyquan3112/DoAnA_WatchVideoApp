import 'package:another_flushbar/flushbar.dart';
import 'package:do_an/models/getUserData.dart';
import 'package:do_an/pages/gamePage.dart';
import 'package:do_an/pages/moviePage.dart';
import 'package:do_an/pages/musicPage.dart';
import 'package:do_an/widgets/my_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class drawerMenu extends StatefulWidget {
  final Function()? onHomePageTap;
  final Function()? onSignOut;
  final Function()? onProfileTap;
  final UserData? userData;
  const drawerMenu({
    super.key,
    required this.onHomePageTap,
    required this.onSignOut,
    required this.onProfileTap,
    this.userData,
  });

  @override
  State<drawerMenu> createState() => _drawerMenuState();
}

class _drawerMenuState extends State<drawerMenu> {
  UserData? currentUser;
  String? userId;
  bool _isLoggedIn = true;

  @override
  void initState() {
    super.initState();
    currentUser = UserData.getCurrentUser();
    if (currentUser?.username != null) {
      setState(() {
        _isLoggedIn = true;
      });
    } else {
      setState(() {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.lightBlueAccent,
          child: Column(
            children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    child: (_isLoggedIn)
                        ? Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(widget.userData!.avatarUrl!),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  '${widget.userData?.username}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Guest',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ),
                          ],
                        )
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                )
              ),
            ),
            MyListTile(
              icon: Icons.home, 
              text: 'H O M E', 
              onTap: widget.onHomePageTap,
            ),
            MyListTile(
              icon: Icons.person, 
              text: 'P R O F I L E', 
              onTap: widget.onProfileTap,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ),
              child: ExpansionTile(
                leading: Icon(
                  Icons.category,
                  color: Colors.white,
                ),
                title: Text(
                  'C A T E G O R I E S',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                children: <Widget>[
                  MyListTile(
                    icon: Icons.music_note, 
                    text: 'Music', 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => (MyMusicApp(
                                  users: currentUser,
                                  isLogin: _isLoggedIn,
                                ))),
                      );
                    },
                  ),
                  MyListTile(
                    icon: Icons.gamepad_rounded, 
                    text: 'Game', 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => (MyGameApp(
                                  users: currentUser,
                                  isLogin: _isLoggedIn,
                                ))),
                      );
                    },
                  ),
                  MyListTile(
                    icon: Icons.movie_sharp, 
                    text: 'Movie', 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => (MyMoviesApp(
                                  users: currentUser,
                                  isLogin: _isLoggedIn,
                                ))),
                      );
                    },
                  ),
                ],
              ),
            ),
            MyListTile(
              icon: Icons.logout, 
              text: 'L O G O U T', 
              onTap: widget.onSignOut,
            ),
          ],
        ),
      );
  }
}