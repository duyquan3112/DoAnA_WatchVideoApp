import 'dart:io';
import 'package:path/path.dart';
import '../widgets/selectFiles.dart';
import 'package:flutter/material.dart';
import 'package:do_an/pages/gamePage.dart';
import 'package:do_an/pages/moviePage.dart';
import 'package:do_an/pages/musicPage.dart';
import 'package:do_an/pages/searchPage.dart';
import 'package:do_an/models/infoVideo.dart';
import 'package:do_an/pages/signInPage.dart';
import 'package:do_an/pages/profilePage.dart';
import 'package:do_an/pages/upLoadVideo.dart';
import 'package:do_an/values/app_assets.dart';
import 'package:do_an/widgets/videoCard.dart';
import 'package:do_an/models/getUserData.dart';
import 'package:do_an/widgets/drawerMenu.dart';
import 'package:do_an/pages/listVideoPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:do_an/widgets/error_SnackBar.dart';
import 'package:do_an/pages/listLikedVideoPage.dart';
import 'package:do_an/pages/personalProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart'

    as slideDialog;


const List<String> list = <String>['Newest', 'Oldest', 'Likest'];

class MyHomePage extends StatefulWidget {
  final UserData users;
  final String userId;
  const MyHomePage({super.key, required this.users, required this.userId});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dropdownValue = list.first;
  String filter = 'date';
  bool isDes = false;

  late int _selectedIndex;
  File? file;
  UserData? currentUser;
  String? userId;
  // infoVideo? infoVid;
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
    currentUser = UserData.getCurrentUser();
    userId = widget.userId;
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

  void handleLogout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      UserData.empty();
      currentUser = null;
      userId = null;
      _isLoggedIn = false;
      _selectedIndex = 0;
    });
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = [
      listVideo(
        isDes: isDes,
        filter: filter,
        users: currentUser,
        userId: userId,
        isLogin: _isLoggedIn,
      ),
      likedVideo(isLogin: _isLoggedIn),
    ];
    //infoVideo? infoVid;
    void gotoProfilePage() {
      if (currentUser == null) {
        // Hiển thị Flushbar nếu currentUser là null
        errorSnackBar(
          errMess: 'Vui lòng login để xem trang cá nhân!',
        ).build(context);
      } else {
        // Điều hướng qua trang personalProfilePage nếu có currentUser
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => personalProfilePage(
                    currentUser: currentUser,
                    isLogin: _isLoggedIn,
                  )),
        );
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          left: 30.0,
                        ),
                        child: const Text(
                          "Home",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                          child: (_isLoggedIn)
                              ? Center(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 35.0,
                                      ),
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            currentUser!.avatarUrl!),
                                      ),
                                      // SizedBox(width: 10),
                                    ],
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 30,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    signInPage()),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors
                                                .white, // Màu văn bản của nút
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 80.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.5), width: 1.0),
                      color: Colors.white),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Search',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 220.0,
                                    ),
                                    Icon(
                                      Icons.search,
                                      color: Colors.lightBlue,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => searchPage(
                              isLogin: _isLoggedIn,
                              users: widget.users,
                            )),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 135,
                  ),
                  Container(
                    height: 1.0,
                    width: 320.0,
                    color: Colors.grey,
                  ),
                  Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 60,
                          width: 270,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  width: 100,
                                  height: 60,
                                  padding: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[200],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Music',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  width: 100,
                                  height: 60,
                                  padding: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[200],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Game',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  width: 100,
                                  height: 60,
                                  padding: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[200],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Movie',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 1,
                          height: 50,
                          child: Container(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),

                        ///menu chon loai sort video
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Container(
                            color: Colors.white,
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                              underline: Container(
                                height: 2,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              onChanged: (String? value) {
                                //khi chon loai sort thi gia tri bien filter va isDes se thay doi theo
                                dropdownValue = value!;
                                if (list.indexOf(value) == 0) {
                                  filter = 'date';
                                  isDes = true;
                                } else if (list.indexOf(value) == 1) {
                                  filter = 'date';
                                  isDes = false;
                                } else {
                                  filter = 'likedCount';
                                  isDes = true;
                                }
                                setState(() {});
                              },
                              items: list.map<DropdownMenuItem<String>>(
                                  (String value) {
                                //hien thi loai sort da chon
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ]),
                  Container(
                    height: 1.0,
                    width: 350.0,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _selectedIndex == 0
                      ? _widgetOptions.elementAt(_selectedIndex)
                      : _isLoggedIn
                          ? _widgetOptions.elementAt(_selectedIndex)
                          : AlertDialog(
                              content: Text('Please Login to use'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    setState(() {
                                      _selectedIndex = 0;
                                    });
                                    _widgetOptions.elementAt(_selectedIndex);
                                  },
                                ),
                                TextButton(
                                  child: const Text('Login'),
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => signInPage()),
                                        (route) => false);
                                  },
                                ),
                              ],
                            ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Builder(
        builder: (context) => drawerMenu(
          userData: UserData.getCurrentUser(),
          onHomePageTap: () {},
          onProfileTap: gotoProfilePage,
          onSignOut: handleLogout,
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50.0,
        backgroundColor: Colors.white,
        color: Colors.lightBlue,
        items: [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(Icons.library_add_outlined, color: Colors.white),
        ],
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        child: Icon(Icons.add),
        onPressed: () {
          if (_isLoggedIn) {
            _showDialog();
          } else {
            errorSnackBar(
              errMess: 'Bạn phải đăng nhập để có thể Upload Video!!',
            ).build(context);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _showDialog() {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    slideDialog.showSlideDialog(
      context: this.context,
      child: selectAndUploadFiles(
        users: currentUser!,
        userId: widget.userId,
      ),
    );
  }
}
