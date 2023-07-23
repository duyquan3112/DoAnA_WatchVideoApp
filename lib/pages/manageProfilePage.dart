import 'package:flutter/material.dart';
import 'package:do_an/pages/homePage.dart';
import 'package:do_an/widgets/info_Box.dart';
import 'package:do_an/models/getUserData.dart';
import 'package:do_an/widgets/drawerMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:do_an/widgets/error_SnackBar.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:do_an/pages/personalProfilePage.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class manageProfilePage extends StatefulWidget {
  const manageProfilePage({super.key});

  @override
  State<manageProfilePage> createState() => _manageProfilePageState();
}

class _manageProfilePageState extends State<manageProfilePage> {
  UserData? currentUser;
  late int _selectedIndex;
  String? userId;
  bool _isLoggedIn = true;

  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
    currentUser = UserData.getCurrentUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      currentUser = null;
      userId = null;
      _isLoggedIn = false;
      _selectedIndex = 0;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(
        users: UserData(uid: ''),
        userId: '',
      )),
    );
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    void gotoProfilePage() {
      errorSnackBar(
          errMess: 'You currently in Profile Page!',
      ).build(context);
    }

    void gotoHomePage() {
      if (currentUser == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    users: currentUser!,
                    userId: userId!,
                  )),
        );
      } else {
        // Điều hướng qua trang personalProfilePage nếu không có currentUser
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    users: UserData(uid: ''),
                    userId: '',
                  )),
        );
      }
    }
    
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawerMenu(
        userData: currentUser,
        onHomePageTap: gotoHomePage,
        onProfileTap: gotoProfilePage,
        onSignOut: _handleLogout,
      ),
      appBar: AppBar(
        title: const Text(
          "Manange Profile",
          style: TextStyle(
            color: Colors.white, 
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(
          padding: const EdgeInsets.only(left:30.0),
          child: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
      ),
      body: Container(
        height: 1000.0,
        child: Stack(
          children: <Widget>[
            ListView(
              children: [
                const SizedBox(
                  height: 50.0,
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    currentUser!.avatarUrl!,
                    scale: 10,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  currentUser!.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                  ),
                  child: Text(
                    'My Details',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0
                    ),
                  ),
                ),
                infoTextBox(
                  text: currentUser!.username!, 
                  sectionName: 'Username'
                ),
                infoTextBox(
                  text: currentUser!.firstName!, 
                  sectionName: 'First name'
                ),
                infoTextBox(
                  text: currentUser!.lastName!, 
                  sectionName: 'Last name'
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}