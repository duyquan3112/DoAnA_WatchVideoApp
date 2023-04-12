import 'dart:io';

import 'package:do_an/values/app_assets.dart';
import 'package:do_an/widgets/videoCard.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart'
    as slideDialog;

import '../widgets/selectFiles.dart';

class MyHomeApp extends StatelessWidget {
  const MyHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {},
            child: const Text('Login'),
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

class listVideo extends StatelessWidget {
  const listVideo({super.key});
  @override
  Widget build(BuildContext context) {
    String uRlVideo = AppAssets.videoDefault;

    return ListView(
      padding: EdgeInsets.all(10),
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          TextButton(
            onPressed: () {},
            child: Text('Am nhac'),
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Tro choi'),
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Phim anh'),
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
            ),
          ),
        ]),
        // Card(
        //   child: ListTile(
        //     isThreeLine: true,
        //     leading: CircleAvatar(),
        //     title: Text('Ten cua Video'),
        //     subtitle: Text('Ho va ten nguoi dung'),
        //     trailing: Icon(Icons.more_vert),
        //   ),
        // ),
        videoCard(uRLVideo: uRlVideo),
      ],
    );
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
