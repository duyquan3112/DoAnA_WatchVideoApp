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
  // final void Function()? onProfileTap;
  final Function()? onSignOut;
  const drawerMenu({super.key, required this.onSignOut});


  
  @override
  State<drawerMenu> createState() => _drawerMenuState();
}

class _drawerMenuState extends State<drawerMenu> {
  UserData? currentUser;
  String? userId;
  bool _isLoggedIn = false;
  
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
                                      NetworkImage(currentUser!.avatarUrl!),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  '${currentUser!.username}',
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
                color: Color.fromARGB(255, 133, 200, 255),
              ),
            ),
            MyListTile(
              icon: Icons.home, 
              text: 'H O M E', 
              onTap: () => Navigator.pop(context),
            ),
            // MyListTile(
            //   icon: Icons.person, 
            //   text: 'P R O F I L E', 
            //   onTap: onProfileTap,
            // ),
            // MyListTile(
            //   icon: Icons.logout, 
            //   text: 'L O G O U T', 
            //   onTap: onSignOut,
            // ),
          ],
        ),
      );
  }
}