import 'package:flutter/material.dart';
import 'package:do_an/pages/homePage.dart';
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
      if (currentUser == true) {
        // Hiển thị Flushbar nếu currentUser là null
        errorSnackBar(
          errMess: 'Bạn đang ở trang cá nhân!',
        ).build(context);
      } else {
        // Điều hướng qua trang personalProfilePage nếu có currentUser
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => personalProfilePage(
                    currentUser: currentUser,
                    isLogin: _isLoggedIn,
                  )),
        );
      }
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
      body: Container(
        height: 1000.0,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                color: Colors.lightBlue,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
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
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 0,
                        ),
                        child: const Text(
                          "Manange Profile",
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),        
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: drawerMenu(
        userData: currentUser,
        onHomePageTap: gotoHomePage,
        onProfileTap: gotoProfilePage,
        onSignOut: _handleLogout,
      ),
    );
  }
}