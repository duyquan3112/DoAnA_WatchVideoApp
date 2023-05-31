// ignore_for_file: library_prefixes

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an/core/local_storage/storage_manager.dart';
import 'package:do_an/pages/game_page.dart';
import 'package:do_an/pages/movie_page.dart';
import 'package:do_an/pages/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart'
    as slideDialog;

import '../core/enums/video_query.dart';
import '../models/get_user_data.dart';
import '../models/info_video.dart';
import '../widgets/select_files.dart';
import 'package:do_an/pages/music_page.dart';

import '../widgets/video_card.dart';
import 'signIn_page.dart';

const List<String> list = <String>['Newest', 'Oldest', 'Likest'];

extension on Query<InfoVideo> {
  /// Create a firebase query from a [VideoQuery]
  Query<InfoVideo> queryBy(VideoQuery query) {
    switch (query) {
      case VideoQuery.newest:
        return orderBy(
          'timeStamp',
          descending: true,
        );
      case VideoQuery.oldest:
        return orderBy(
          'timeStamp',
        );
      case VideoQuery.likesDesc:
        return orderBy(
          'likedCount',
          descending: query == VideoQuery.likesDesc,
        );
    }
  }
}

class MyHomePage extends StatefulWidget {
  final UserData? users;
  final String? userId;
  const MyHomePage({
    super.key,
    this.users,
    this.userId,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dropdownValue = list.first;
  String filter = 'date';
  bool isDes = false;

  int? _selectedIndex;
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

  final videosRef = FirebaseFirestore.instance
      .collection('video_list')
      .withConverter<InfoVideo>(
        fromFirestore: (snapshots, _) => InfoVideo.fromJson(snapshots.data()!),
        toFirestore: (video, _) => video.toJson(),
      );

  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
    // currentUser = UserData.getCurrentUser();
    // userId = widget.userId;
    // if (currentUser?.username != null) {
    //   setState(() {
    //     _isLoggedIn = true;
    //   });
    // } else {
    //   setState(() {
    //     _isLoggedIn = false;
    //   });
    // }
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

  VideoQuery query = VideoQuery.newest;
  @override
  Widget build(BuildContext context) {
    // List<Widget> _widgetOptions = [
    //   ListVideo(
    //     isDes: isDes,
    //     filter: filter,
    //     users: currentUser,
    //     userId: userId,
    //     isLogin: _isLoggedIn,
    //   ),
    //   ListVideo(isLogin: _isLoggedIn),
    // ];
    return Scaffold(
      drawer: drawer(context),
      appBar: AppBar(
        title: const Text("Home page"),
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
                    builder: (context) => SearchPage(
                      users: widget.users,
                      isLogin: _isLoggedIn,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.search)),
          SizedBox(
            child: StorageManager.instance.userCurrent != null
                ? Center(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(currentUser!.avatarUrl!),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          currentUser!.username!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
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
                        MaterialPageRoute(
                            builder: (context) => const SignInPage()),
                      );
                    },
                    child: const Text('Login'),
                  ),
          ),
          // TextButton(
          //   onPressed: () {
          //     _handleLogout();
          //   },
          //   child: Text('Logout'),
          //   style: ButtonStyle(
          //     backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
          //   ),
          // ),
        ],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: PopupMenuButton<VideoQuery>(
              onSelected: (value) => setState(() => query = value),
              icon: const Icon(Icons.sort),
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: VideoQuery.newest,
                    child: Text('Sort by Newest'),
                  ),
                  const PopupMenuItem(
                    value: VideoQuery.oldest,
                    child: Text('Sort by Oldest'),
                  ),
                  const PopupMenuItem(
                    value: VideoQuery.likesDesc,
                    child: Text('Sort by Likest'),
                  ),
                ];
              },
            ),
          ),
          StreamBuilder<QuerySnapshot<InfoVideo>>(
              stream: videosRef.queryBy(query).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.requireData;
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      return VideoCard(
                        infoVid: data.docs[index].data(),
                      );
                    },
                  ),
                );
              }),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(right: 12.0),
          //       child: DropdownButton<String>(
          //         value: dropdownValue,
          //         icon: const Icon(Icons.arrow_downward),
          //         elevation: 16,
          //         style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          //         underline: Container(
          //           height: 2,
          //           color: const Color.fromARGB(255, 0, 0, 0),
          //         ),
          //         onChanged: (String? value) {
          //           //khi chon loai sort thi gia tri bien filter va isDes se thay doi theo
          //           dropdownValue = value!;
          //           if (list.indexOf(value) == 0) {
          //             filter = 'date';
          //             isDes = true;
          //           } else if (list.indexOf(value) == 1) {
          //             filter = 'date';
          //             isDes = false;
          //           } else {
          //             filter = 'likedCount';
          //             isDes = true;
          //           }
          //           setState(() {});
          //         },
          //         items: list.map<DropdownMenuItem<String>>((String value) {
          //           //hien thi loai sort da chon
          //           return DropdownMenuItem<String>(
          //             value: value,
          //             child: Text(value),
          //           );
          //         }).toList(),
          //       ),
          //     ),
          //   ],
          // ),
          // _selectedIndex == 0
          //     ? _widgetOptions.elementAt(_selectedIndex ?? 0)
          //     : _isLoggedIn
          //         ? _widgetOptions.elementAt(_selectedIndex ?? 0)
          //         : AlertDialog(
          //             content: const Text('Please Login to use'),
          //             actions: <Widget>[
          //               TextButton(
          //                 child: const Text('Cancel'),
          //                 onPressed: () {
          //                   setState(() {
          //                     _selectedIndex = 0;
          //                   });
          //                   _widgetOptions.elementAt(_selectedIndex ?? 0);
          //                 },
          //               ),
          //               TextButton(
          //                 child: const Text('Login'),
          //                 onPressed: () {
          //                   Navigator.of(context).pushAndRemoveUntil(
          //                       MaterialPageRoute(
          //                           builder: (context) => const signInPage()),
          //                       (route) => false);
          //                 },
          //               ),
          //             ],
          //           ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          if (_isLoggedIn) {
            _showDialog();
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SignInPage(),
              ),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_add_outlined), label: 'Liked Video'),
        ],
        currentIndex: _selectedIndex ?? 0,
        selectedItemColor: const Color.fromARGB(255, 0, 94, 255),
        selectedIconTheme: const IconThemeData(
          size: 30,
        ),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        backgroundColor: const Color.fromARGB(255, 190, 227, 255),
        onTap: _onItemTapped,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _showDialog() {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    slideDialog.showSlideDialog(
      context: this.context,
      child: SelectAndUploadFiles(
        users: currentUser!,
        userId: widget.userId,
      ),
      // barrierColor: Colors.white.withOpacity(0.7),
      // pillColor: Colors.red,
      // backgroundColor: Colors.yellow,
    );
  }

  Future<void> _resetLikes() async {
    final videos = await videosRef.get();
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (final video in videos.docs) {
      batch.update(video.reference, {'likedCount': 0});
    }
    await batch.commit();
  }

  Widget drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // TODO: Add navigation logic here
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // TODO: Add navigation logic here
            },
          ),
          ExpansionTile(
            leading: const Icon(Icons.category),
            title: const Text('Category'),
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.music_note),
                title: const Text('Music'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (MyMusicApp(
                              users: currentUser,
                              isLogin: _isLoggedIn,
                            ))),
                  );
                  // TODO: Add navigation logic here
                },
              ),
              ListTile(
                leading: const Icon(Icons.gamepad_rounded),
                title: const Text('Game'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (MyGameApp(
                              users: currentUser,
                              isLogin: _isLoggedIn,
                            ))),
                  );
                  // TODO: Add navigation logic here
                },
              ),
              ListTile(
                leading: const Icon(Icons.movie_sharp),
                title: const Text('Movies'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => (MyMoviesApp(
                              users: currentUser,
                              isLogin: _isLoggedIn,
                            ))),
                  );
                  // TODO: Add navigation logic here
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              _handleLogout();
              // TODO: Add navigation logic here
            },
          ),
        ],
      ),
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

//                         return VideoCard(
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
