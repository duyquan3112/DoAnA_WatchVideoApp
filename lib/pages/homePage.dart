import 'dart:io';

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

class MyHomeApp extends StatefulWidget {
  const MyHomeApp({super.key});

  @override
  State<MyHomeApp> createState() => _MyHomeAppState();
}

class _MyHomeAppState extends State<MyHomeApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Page',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  File? file;
  final List<Widget> _widgetOptions = [
    listVideo(),
    Text(''),
    likedVideo(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  UserData _user = UserData.empty();
  String username = '';

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  Future<void> _initUser() async {
    User? firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      setState(() {
        _user = UserData(
          uid: firebaseUser.uid ,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
          // photoUrl: firebaseUser.photoURL ?? '',
        );
      });
    } else {
      setState(() {
        _user = UserData.empty();
      });
    }
  }

  void _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _user.isSignedIn;
    });
    _initUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          SizedBox(
            child: _user.isSignedIn
            ? Center(
              child: Text(
                '${_user.displayName}  ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                )
              )
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
                  _showDialog();
                },
              ),
              label: ''),
          BottomNavigationBarItem(
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
      child: selectAndUploadFiles(),
      // barrierColor: Colors.white.withOpacity(0.7),
      // pillColor: Colors.red,
      // backgroundColor: Colors.yellow,
    );
  }
}

class listVideo extends StatefulWidget {
  const listVideo({super.key});

  @override
  State<listVideo> createState() => _listVideoState();
}

class _listVideoState extends State<listVideo> {
  @override
  Widget build(BuildContext context) {
    String uRlVideo = AppAssets.videoDefault;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('video_list').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text('Music'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Game'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Movies'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.black),
                        ),
                      ),
                    ]),
                Flexible(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        infoVideo info = infoVideo();
                        info.description =
                            snapshot.data!.docs[index]['description'];
                        info.title = snapshot.data!.docs[index]['title'];
                        info.url = snapshot.data!.docs[index]['videoUrl'];
                        info.vidId = snapshot.data!.docs[index].id;
                        return videoCard(
                          // uRLVideo: snapshot.data!.docs[index]['videoUrl'],
                          // title: snapshot.data!.docs[index]['title'],
                          // des: snapshot.data!.docs[index]['description'],
                          // vidId: snapshot.data!.docs[index].id,
                          infoVid: info,
                        );
                      }
                      // Card(
                      //     child: ListTile(
                      //   isThreeLine: true,
                      //   leading: CircleAvatar(),
                      //   title: Text(snapshot.data!.docs[index]['title']),
                      //   subtitle: Text(snapshot.data!.docs[index]['description']),
                      //   trailing: Icon(Icons.more_vert),
                      // )),
                      ),
                ),
              ],
            );
          } else {
            return Center(child: const Text('No data'));
          }
        });
  }
}

class likedVideo extends StatelessWidget {
  const likedVideo({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(child: Text("This is liked video"));
  }
}
