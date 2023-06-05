import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an/pages/signInPage.dart';
import 'package:do_an/widgets/error_SnackBar.dart';
import 'package:do_an/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class forgotPage extends StatefulWidget {
  const forgotPage({super.key});

  @override
  State<forgotPage> createState() => _forgotPageState();
}

class _forgotPageState extends State<forgotPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
    } on FirebaseAuthException catch(e) {
      String errorMessage = '';
      if(e.code == 'user-not-found') {
        errorMessage = 'Không tìm thấy người dùng có địa chỉ email này';
      } else if ( emailController.text.isEmpty) {
        errorMessage = 'Vui lòng nhập mail để tiến hành thay đổi mật khẩu';
      }else {
        errorMessage = 'Đã gửi link reset mật khẩu';
      }
      errorSnackBar(errMess: errorMessage).build(context);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => signInPage()),
            );
          },
        ),
      ),
      body: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your Email and we will send you a password reset link!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
      
            SizedBox(
              height: 20,
            ),
      
            // Emailname textfield
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
      
            SizedBox(
              height: 20,
            ),
      
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: Colors.white54,
                  width: 1.0,
                ),
              ),
              child: MaterialButton(
                onPressed: () {
                  passwordReset();
                }, 
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}