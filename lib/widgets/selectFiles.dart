import 'dart:io';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:path/path.dart';
import '../api/firebase_api.dart';
import '../pages/upLoadVideo.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:do_an/models/getUserData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:firebase_storage/firebase_storage.dart';



const List<String> list = <String>['Movies', 'Games', 'Musics'];

class selectAndUploadFiles extends StatefulWidget {
  final UserData users;
  final String userId;
  const selectAndUploadFiles(
      {super.key, required this.users, required this.userId});

  @override
  State<selectAndUploadFiles> createState() => _selectAndUploadFilesState();
}

class _selectAndUploadFilesState extends State<selectAndUploadFiles> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  UploadTask? task;
  File? file;

  String? urlDownload;

  String dropdownValue = list.first;

  int? _type;

  var types = <String>[
    'Movies',
    'Games',
    'Musics',
  ];
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    value:
    _type == null ? null : types[_type!];
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          title(),
          description(),
          TextButton(
            onPressed: () {
              selectFile();
            },
            child: Text('Select Files'),
          ),
          Text(
            fileName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
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
              await upLoadFile();
              // pushFile();
              pushData();
            },
            child: Text('UpLoadVideo'),
          ),
          task != null ? buildUploadStatus(task!) : Container(),
        ],
      ),
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

  Future pushData() async {
    pushFile(titleController.text, descriptionController.text);
  }

  Future pushFile(String title, String description) async {
    final thumbnailBytes = await generateThumbnail(urlDownload!);
    final thumbnailUrl = await uploadThumbnail(urlDownload!, thumbnailBytes!);
    var date = DateTime.now();
                    var formattedDate = formatDate(date, [
                      dd,
                      '/',
                      mm,
                      '/',
                      yyyy,
                      ' ',
                      HH,
                      ':',
                      nn,
                    ]);
    await FirebaseFirestore.instance.collection('video_list').add({
      'title': title,
      'description': description,
      'videoUrl': urlDownload,
      'thumbnailUrl': thumbnailUrl,
      'type': await getTypeVideo(),
      'ownerId': widget.userId,
      'ownerName': widget.users.username,
      'likedCount': 0,
      'date': formattedDate, 
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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future upLoadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  //generate thumbnail byte
  Future<Uint8List?> generateThumbnail(String videoPath) async {
  final thumbnailBytes = await VideoThumbnail.thumbnailData(
    video: videoPath,
    imageFormat: ImageFormat.JPEG,
    maxHeight: 512,
    maxWidth: 512,
    quality: 50,
  );
  return thumbnailBytes;
}
//upload thumbail to firebase and get url
  Future<String> uploadThumbnail(String videoPath, Uint8List thumbnailBytes) async {
  final storage = FirebaseStorage.instance;
  
  // Generate a unique filename for the thumbnail
  final thumbnailFileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
  
  // Create a reference to the thumbnail location in Firebase Storage
  final thumbnailRef = storage.ref().child('thumbnails/$thumbnailFileName');
  
  // Upload the thumbnail bytes to Firebase Storage
  await thumbnailRef.putData(thumbnailBytes);
  
  // Get the download URL of the uploaded thumbnail
  final thumbnailUrl = await thumbnailRef.getDownloadURL();
  
  return thumbnailUrl;
}


  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}
