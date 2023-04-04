import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyProfilePage(title: 'Home Page'),
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 20, 0, 0),
        child: Expanded(
          flex: 1,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Container(
                  //         child: Image.network(
                  //             'https://media.istockphoto.com/id/1145618475/vi/anh/villefranche-tr%C3%AAn-bi%E1%BB%83n-v%C3%A0o-bu%E1%BB%95i-t%E1%BB%91i.jpg?s=1024x1024&w=is&k=20&c=XoPFOytGtsMJwiH_dZu6Hf19Y9NUGN6mos4aiONb8bc=',
                  //             fit: BoxFit.fill),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: [
                      CircleAvatar(
                        child: Text('avatar'),
                      ),
                      Column(
                        children: [Text("Ten video"), Text("Description")],
                      ),
                      Icon(Icons.donut_large)
                    ],
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [],
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        child: Text('avatar'),
                      ),
                      Column(
                        children: [Text("Ten video"), Text("Description")],
                      ),
                      Icon(Icons.donut_large)
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline), label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.library_add_outlined), label: ''),
      ]),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
