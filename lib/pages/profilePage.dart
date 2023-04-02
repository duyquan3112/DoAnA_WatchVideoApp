import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyProfilePage(title: 'Profile Page'),
    );
  }
}

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key, required this.title});
  final String title;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        // actions: <Widget>[
        //   Row(
        //     children: [
        //       IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back))
        //     ],
        //   )
        // ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 200, 0),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {},
                  iconSize: 40,
                ),
              ),
              IconButton(
                icon: Icon(Icons.alarm),
                onPressed: () {},
                alignment: Alignment.center,
                iconSize: 40,
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
                alignment: Alignment.center,
                iconSize: 40,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Container(
                        height: 100,
                        width: 411,
                        child: Image.network(
                            'https://media.istockphoto.com/id/1145618475/vi/anh/villefranche-tr%C3%AAn-bi%E1%BB%83n-v%C3%A0o-bu%E1%BB%95i-t%E1%BB%91i.jpg?s=1024x1024&w=is&k=20&c=XoPFOytGtsMJwiH_dZu6Hf19Y9NUGN6mos4aiONb8bc=',
                            fit: BoxFit.fill),
                      ),
                      // ignore: prefer_const_constructors
                      Positioned(
                        bottom: -10,
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          textStyle: TextStyle(fontSize: 20),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(5)),
                      onPressed: () {},
                      child: const Text("Edit Profile"),
                    ),
                    Text('Name')
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 2, color: Colors.black),
                  bottom: BorderSide(width: 2, color: Colors.black),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(width: 4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text("Home"),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        // padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        textStyle: TextStyle(fontSize: 20),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text("Liked Video"),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        // padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        textStyle: TextStyle(fontSize: 20),
                        // backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
