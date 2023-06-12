import 'dart:io';
import 'package:do_an/pages/gamePage.dart';
import 'package:do_an/pages/listLikedVideoPage.dart';
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
        isDes: isDes,
        filter: filter,
        users: currentUser,
        userId: userId,
        isLogin: _isLoggedIn,
      ),
      likedVideo(isLogin: _isLoggedIn),
    ];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            toolbarHeight: 50,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.menu),
                  color: Colors.black,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: const Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            actions: [
              SizedBox(
                  child: (_isLoggedIn)
                      ? Center(
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(currentUser!.avatarUrl!),
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
                                        builder: (context) => signInPage()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white, // Màu văn bản của nút
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Container(
                height: 50,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.5), width: 1.0),
                        color: Color.fromARGB(255, 236, 236, 236),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10.0),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search",
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              print("your menu action here");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
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
                                )),
                              ],
                            )),
                ],
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 133, 200, 255),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // TODO: Add navigation logic here
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            ExpansionTile(
              leading: Icon(Icons.category),
              title: Text('Category'),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.music_note),
                  title: Text('Music'),
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
                ListTile(
                  leading: Icon(Icons.gamepad_rounded),
                  title: Text('Game'),
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
                ListTile(
                  leading: Icon(Icons.movie_sharp),
                  title: Text('Movies'),
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
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                _handleLogout();
                // TODO: Add navigation logic here
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
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
                      style:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
                      items: list.map<DropdownMenuItem<String>>((String value) {
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => signInPage()),
                            );
                          },
                        ),
                      ],
                    ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
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

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.library_add_outlined), label: 'Liked Video'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 0, 94, 255),
          selectedIconTheme: IconThemeData(
            size: 30,
          ),
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          backgroundColor: Color.fromARGB(255, 190, 227, 255),
          onTap: _onItemTapped,
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
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
      // barrierColor: Colors.white.withOpacity(0.7),
      // pillColor: Colors.red,
      // backgroundColor: Colors.yellow,
    );
  }
}

// class listVideo extends StatefulWidget {
//   final UserData? users;
//   final String userId;
//   const listVideo({super.key, required this.users, required this.userId});

//   @override
//   State<listVideo> createState() => _listVideoState();
// }

// class _listVideoState extends State<listVideo> {
//   @override
//   Widget build(BuildContext context) {
//     String uRlVideo = AppAssets.videoDefault;

//     return StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('video_list').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasData) {
//             return Column(
//               children: [
//                 Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => (MyMusicApp(
//                                       users: widget.users!,
//                                     ))),
//                           );
//                         },
//                         child: Text('Music'),
//                         style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStatePropertyAll<Color>(Colors.black),
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => (MyGameApp(
//                                       users: widget.users,
//                                     ))),
//                           );
//                         },
//                         child: Text('Game'),
//                         style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStatePropertyAll<Color>(Colors.black),
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => (MyMoviesApp(
//                                       users: widget.users!,
//                                     ))),
//                           );
//                         },
//                         child: Text('Movies'),
//                         style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStatePropertyAll<Color>(Colors.black),
//                         ),
//                       ),
//                     ]),
//                 Divider(
//                   height: 1,
//                   color: Colors.grey,
//                   thickness: 1,
//                   indent: 16,
//                   endIndent: 16,
//                 ),
//                 Flexible(
//                   child: ListView.builder(
//                       physics: const BouncingScrollPhysics(),
//                       padding: const EdgeInsets.all(8),
//                       shrinkWrap: true,
//                       itemCount: snapshot.data!.docs.length,
//                       itemBuilder: (context, index) {
//                         infoVideo info = infoVideo();
//                         info.description =
//                             snapshot.data!.docs[index]['description'];
//                         info.title = snapshot.data!.docs[index]['title'];
//                         info.url = snapshot.data!.docs[index]['videoUrl'];
//                         info.vidId = snapshot.data!.docs[index].id;
//                         info.userId = snapshot.data!.docs[index]['ownerId'];
//                         info.types = snapshot.data!.docs[index]['type'];
//                         info.ownerName =
//                             snapshot.data!.docs[index]['ownerName'];

//                         return videoCard(
//                           users: widget.users,
//                           // uRLVideo: snapshot.data!.docs[index]['videoUrl'],
//                           // title: snapshot.data!.docs[index]['title'],
//                           // des: snapshot.data!.docs[index]['description'],
//                           // vidId: snapshot.data!.docs[index].id,
//                           infoVid: info,
//                         );
//                       }
//                       // Card(
//                       //     child: ListTile(
//                       //   isThreeLine: true,
//                       //   leading: CircleAvatar(),
//                       //   title: Text(snapshot.data!.docs[index]['title']),
//                       //   subtitle: Text(snapshot.data!.docs[index]['description']),
//                       //   trailing: Icon(Icons.more_vert),
//                       // )),
//                       ),
//                 ),
//               ],
//             );
//           } else {
//             return Center(child: const Text('No data'));
//           }
//         });
//   }
// }

// class likedVideo extends StatelessWidget {
//   const likedVideo({super.key});
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Center(child: Text("This is liked video"));
//   }
// }
