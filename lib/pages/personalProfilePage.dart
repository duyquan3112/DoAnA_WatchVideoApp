import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:do_an/pages/homePage.dart';
import 'package:do_an/models/infoVideo.dart';
import 'package:do_an/pages/signInPage.dart';
import 'package:do_an/widgets/editVideo.dart';
import 'package:do_an/widgets/videoCard.dart';
import 'package:do_an/models/getUserData.dart';
import 'package:do_an/widgets/drawerMenu.dart';
import 'package:do_an/widgets/deleteVideo.dart';
import 'package:do_an/widgets/selectFiles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:do_an/widgets/error_SnackBar.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart'
    as slideDialog;

class personalProfilePage extends StatefulWidget {
  final UserData? currentUser;
  final bool isLogin;
  // final infoVideo info;
  // final infoVideo info;
  const personalProfilePage({
    super.key,
    required this.isLogin,
    required this.currentUser,
    // required this.info,
    // required this.info,
  });

  @override
  State<personalProfilePage> createState() => _personalProfilePageState();
}

class _personalProfilePageState extends State<personalProfilePage> {
  File? file;
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
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final user1 = widget.currentUser;
    final isLogin = widget.isLogin;
    final docid = user1?.docId;
    final name = widget.currentUser!.username;
    var videos = FirebaseFirestore.instance.collection('video_list');

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

    void _showDialog() {
      final fileName = file != null ? basename(file!.path) : 'No File Selected';
      slideDialog.showSlideDialog(
        context: this.context,
        child: selectAndUploadFiles(
          users: currentUser!,
          userId: currentUser!.docId!,
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          height: 1000.0,
          child: Stack(children: <Widget>[
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
                          left: 0,
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
                      Icon(
                        Icons.logout,
                      )
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Under Maintenance ( Đang Fixbug )",
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.lightBlue,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 150,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(currentUser!.avatarUrl!),
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
                            '${user1?.username}', // name cua chu video lay tu trong infovideo
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
                          //_showDialog();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          // padding: EdgeInsets.fromLTRB(0, 20, 0, 20),

                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Edit video"),
                      ),
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.black,
                    //     border: Border.all(width: 4),
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   // child: deleteVideo(
                    //   //   info: widget.info,
                    //   // ),
                    // ),
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
                        // ignore: avoid_print hct
                        onPressed: () => print('chang to manage profile page'),
                        child: const Text('Manage Profile'))
                  ],
                ),

                //render video co dieu kien hct
                StreamBuilder(
                    stream: videos.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return Flexible(
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(8),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                infoVideo info = infoVideo();
                                info.description =
                                    snapshot.data!.docs[index]['description'];
                                info.title =
                                    snapshot.data!.docs[index]['title'];
                                info.url =
                                    snapshot.data!.docs[index]['videoUrl'];
                                info.vidId = snapshot.data!.docs[index].id;
                                info.userId =
                                    snapshot.data!.docs[index]['ownerId'];
                                info.types = snapshot.data!.docs[index]['type'];
                                info.ownerName =
                                    snapshot.data!.docs[index]['ownerName'];
                                info.likedCount =
                                    snapshot.data!.docs[index]['likedCount'];
                                // name owner == name cua video thi moi hien thi video cua user do hct
                                if (info.userId == widget.currentUser!.docId) {
                                  return videoCard(
                                    key: UniqueKey(),
                                    users: user1,
                                    // uRLVideo: snapshot.data!.docs[index]['videoUrl'],
                                    // title: snapshot.data!.docs[index]['title'],
                                    // des: snapshot.data!.docs[index]['description'],
                                    // vidId: snapshot.data!.docs[index].id,
                                    infoVid: info,
                                    isLogin: widget.isLogin,
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        );
                      }
                      return const Text('no data');
                    })
              ],
            ),
          ])),
      drawer: drawerMenu(
        userData: currentUser,
        onHomePageTap: gotoHomePage,
        onProfileTap: gotoProfilePage,
        onSignOut: _handleLogout,
      ),
      bottomNavigationBar: CurvedNavigationBar(
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
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => signInPage()));
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  // void _showDialog() {
  //   slideDialog.showSlideDialog(
  //     context: this.context,
  //     child: editVideo(
  //       info: widget.info,
  //     ),
  //   );
  // }
}
