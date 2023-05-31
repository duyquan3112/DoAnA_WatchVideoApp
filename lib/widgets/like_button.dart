import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an/models/info_video.dart';
import 'package:flutter/material.dart';
import '../core/local_storage/storage_manager.dart';
import '../models/get_user_data.dart';
import '../values/app_assets.dart';
import '../values/app_styles.dart';

class LikeButton extends StatefulWidget {
  final InfoVideo? info;
  final bool isLogin;
  const LikeButton({
    super.key,
    this.info,
    this.isLogin = false,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  UserData? currentUser;
  bool? isLiked = false;

  /// Ham quan ly su kien khi nhan nut like
  Future onLikeButtonTapped() async {
    if (!widget.isLogin) {
      //Handle khi chua login, hien thi SnackBar de thong bao
      const snackbar = SnackBar(
        content: Text('Please Login to react!'),
        showCloseIcon: true,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      //Handle truong hop nguoi dung da like video
      var likedCountRef = FirebaseFirestore.instance
          .collection('video_list')
          .doc(widget.info?.vidId ?? '');
      isLiked!
          ? {
              //neu da like thi so luot like se -1 va isLike = false, sau do se cap nhat lai database
              await likedCountRef
                  .update({'likedCount': --widget.info?.likedCount}),
              await deleteLikedVideo(), //Xoa video khoi danh sach da yeu thich
              setState(() {
                isLiked = !isLiked!;
              })
            }
          : {
              //neu chua like thi so luot like se +1 va isLike = true, sau do se cap nhat lai database
              await likedCountRef
                  .update({'likedCount': ++widget.info?.likedCount}),
              await addLikedVideo(), //Them video khoi danh sach da yeu thich
              setState(() {
                isLiked = !isLiked!;
              })
            };
    }
  }

  ///Ham them video da like va thong tin user like video vao database
  Future addLikedVideo() async {
    var collection = FirebaseFirestore.instance.collection('liked_video');
    await collection
        .add({'userId': currentUser!.docId, 'vidId': widget.info?.vidId});
  }

  ///Xoa video khoi danh sach video da yeu thich
  Future deleteLikedVideo() async {
    var collection = FirebaseFirestore.instance.collection('liked_video');
    await collection.doc(await getLikedDocId()).delete();
  }

  ///Ham lay docId cua video ma nguoi dung da yeu thich
  Future<String> getLikedDocId() async {
    String? res;
    var collection = FirebaseFirestore.instance.collection('liked_video');
    await collection.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['userId'] == currentUser!.docId &&
            doc['vidId'] == widget.info?.vidId) {
          res = doc.id;
          break;
        }
      }
    });
    return res!;
  }

  ///Ham kiem tra video da duoc nguoi dung like hay chua
  Future<bool> checkLiked() async {
    bool? res;
    var collection = FirebaseFirestore.instance.collection('liked_video');
    var docs = collection
        .where('userId', isEqualTo: currentUser!.docId)
        .where('vidId', isEqualTo: widget.info?.vidId)
        .get();

    await docs.then((values) {
      res = values.docs.isNotEmpty;
      return res;
    });
    return res!;
  }

  ///Ham khoi tao bien flag quan ly su kien like cua nguoi dung
  ///Neu nguoi dung da like tu truoc thi isLiked = true va nguoc lai
  Future<void> setUpLikedFlag() async {
    if (widget.isLogin) {
      isLiked = await checkLiked();
      setState(() {
        isLiked;
      });
    } else {
      setState(() {
        isLiked = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      currentUser = StorageManager.instance.userCurrent;
      ;
    });
    setUpLikedFlag();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    int likeCount = widget.info?.likedCount ?? 0;
    return SizedBox(
      width: size.width * 1 / 3,
      child: TextButton.icon(
          onPressed: onLikeButtonTapped,
          icon: ImageIcon(
            AssetImage(AppAssets.heart),
            color:
                isLiked! ? const Color.fromARGB(255, 238, 0, 52) : Colors.grey,
          ),
          label: Text('$likeCount',
              style: AppStyles.h4.copyWith(color: Colors.black))),
    );
  }
}
