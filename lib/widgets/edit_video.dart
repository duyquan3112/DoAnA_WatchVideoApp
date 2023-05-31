import 'package:do_an/models/info_video.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const List<String> list = <String>['Movies', 'Games', 'Musics'];

class EditVideo extends StatefulWidget {
  final InfoVideo? info;
  const EditVideo({
    super.key,
    this.info,
  });

  @override
  State<EditVideo> createState() => _EditVideoState();
}

class _EditVideoState extends State<EditVideo> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String dropdownValue = list.first;

  int? _type;

  var types = <String>[
    'Movies',
    'Games',
    'Musics',
  ];

  @override
  Widget build(BuildContext context) {
    value:
    _type == null ? null : types[_type!];
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          title(),
          description(),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.blue),
            underline: Container(
              height: 2,
              color: Colors.blue,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
                _type = types.indexOf(value);
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          TextButton(
            onPressed: () async {
              // await upLoadFile();
              // pushFile();
              if (titleController.text.isEmpty) {
                await Update(await getVideoData(1), descriptionController.text,
                    await getTypeVideo());
              } else if (descriptionController.text == null) {
                await Update(await getVideoData(0), titleController.text,
                    await getTypeVideo());
              } else if (titleController.text == null &&
                  descriptionController.text == null) {
                await Update(await getVideoData(1), await getVideoData(0),
                    await getTypeVideo());
              } else {
                await Update(titleController.text, descriptionController.text,
                    await getTypeVideo());
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // build title
  Widget title() => Container(
        margin: const EdgeInsets.all(15),
        child: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            hintText: 'Title',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        ),
      );

  // build Discription
  Widget description() => Container(
        margin: const EdgeInsets.all(15),
        child: TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            hintText: 'Description',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        ),
      );

  Future<String> getVideoData(int flag) async {
    var collection = FirebaseFirestore.instance.collection("video_list");
    String description;
    String title;
    var docRef = await collection.doc(widget.info?.vidId).get();
    // var docRef = db.collection("video_list").doc(widget.info.vidId);
    Map<String, dynamic>? data = docRef.data();
    if (flag == 0) {
      description = data?['description'];
      return description;
    }
    title = data?['title'];
    return title;
  }

  Future Update(String title, String description, String type) async {
    var db = FirebaseFirestore.instance;
    var docRef = db.collection("video_list").doc(widget.info?.vidId);
    await docRef.update({
      'title': title,
      'description': description,
      'type': type,
    });
  }

  Future<String> getTypeVideo() async {
    String tmp = '';
    if (_type == 0) {
      return tmp = 'movies';
    } else if (_type == 1) {
      return tmp = 'games';
    }
    return tmp = 'musics';
  }
}
