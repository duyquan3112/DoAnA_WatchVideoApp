import '../widgets/editVideo.dart';
import '../widgets/videoCard.dart';
import '../models/getUserData.dart';
import '../widgets/deleteVideo.dart';
import 'package:flutter/material.dart';
import 'package:do_an/pages/homePage.dart';
import 'package:do_an/models/infoVideo.dart';
import 'package:do_an/widgets/editVideo.dart';
import 'package:do_an/widgets/drawerMenu.dart';
import 'package:do_an/pages/listVideoPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:do_an/widgets/error_SnackBar.dart';
import 'package:do_an/pages/personalProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart'

    as slideDialog;


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
  UserData? currentUser;
  late int _selectedIndex;
  String? userId;
  bool _isLoggedIn = true;

  void _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      currentUser = null;
      userId = null;
      _isLoggedIn = false;
      _selectedIndex = 0;
    });
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
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  build(BuildContext context) {
    final user1 = widget.user;
    final isLogin = widget.isLogin;
    final docid = user1?.docId;
    final name = widget.info.ownerName;
    var videos = FirebaseFirestore.instance.collection('video_list');

    //QuerySnapshot vidbelongtodocid = await firestore.collection('videos').where
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Profile",
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
      drawer: drawerMenu(
        userData: currentUser,
        onHomePageTap: gotoHomePage,
        onProfileTap: gotoProfilePage,
        onSignOut: _handleLogout,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Container(
          //   color: Colors.blue,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.fromLTRB(0, 0, 200, 0),
          //         child: IconButton(
          //           icon: Icon(Icons.arrow_back),
          //           onPressed: () {},
          //           iconSize: 40,
          //         ),
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.alarm),
          //         onPressed: () {},
          //         alignment: Alignment.center,
          //         iconSize: 40,
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.search),
          //         onPressed: () {},
          //         alignment: Alignment.center,
          //         iconSize: 40,
          //       )
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        //backgroundImage: NetworkImage(user1!.avatarUrl),
                        backgroundColor: Colors.red,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '$name', // name cua chu video lay tu trong infovideo
                      style: TextStyle(fontSize: 30),
                    )
                  ],
                )
              ],
            ),
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
                          info.title = snapshot.data!.docs[index]['title'];
                          info.url = snapshot.data!.docs[index]['videoUrl'];
                          info.vidId = snapshot.data!.docs[index].id;
                          info.userId = snapshot.data!.docs[index]['ownerId'];
                          info.types = snapshot.data!.docs[index]['type'];
                          info.ownerName =
                              snapshot.data!.docs[index]['ownerName'];
                          info.likedCount =
                              snapshot.data!.docs[index]['likedCount'];
                          //name owner == name cua video thi moi hien thi video cua user do hct
                          if (info.ownerName == name) {
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
              }
            )
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
