import 'dart:io';
import 'dart:ffi';
import 'package:path/path.dart';
import '../api/firebase_api.dart';
import '../pages/upLoadVideo.dart';
import 'package:flutter/material.dart';
import 'package:do_an/models/infoVideo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:do_an/models/getUserData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';



const List<String> list = <String>['Movies', 'Games', 'Musics'];

class editVideo extends StatefulWidget {
  final infoVideo info;
  const editVideo(
      {super.key, required this.info});


  @override
  State<editVideo> createState() => _editVideoState();
}

class _editVideoState extends State<editVideo> {
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
    return Column(
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
            if(titleController.text ==null){
             await Update(await getVideoData(1), descriptionController.text, await getTypeVideo());
            }else if(descriptionController.text == null){
             await Update(await getVideoData(0), titleController.text, await getTypeVideo());
            }else if(titleController.text ==null && descriptionController.text == null){
              await Update(await getVideoData(1), await getVideoData(0), await getTypeVideo());
            }else{
              await Update(titleController.text, descriptionController.text, await getTypeVideo());
            }
          },
          child: Text('Update'),
        ),
       
      ],
    );
  }

  // build title
  Widget title() => Container(
        margin: EdgeInsets.all(15),
        child: TextField(
          controller: titleController,
          decoration: InputDecoration(
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
        margin: EdgeInsets.all(15),
        child: TextField(
          controller: descriptionController,
          decoration: InputDecoration(
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
    var docRef = await collection.doc(widget.info.vidId).get();
    // var docRef = db.collection("video_list").doc(widget.info.vidId);
    Map<String, dynamic>? data = docRef.data();
    if(flag == 0){
       description = data?['description'];
       return description;
      }
    title = data?['title'];
    return title;
      
  }

  Future Update(String title, String description, String type) async {
    var db = FirebaseFirestore.instance;
    var docRef = db.collection("video_list").doc(widget.info.vidId);
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


