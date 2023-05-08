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
      } else {
        errorMessage = 'Đã gửi link reset mật khẩu';
      }
      errorSnackBar(errMess: errorMessage).build(context);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
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

          MaterialButton(
            onPressed: () {
              passwordReset();
            }, 
            child: Text(
              'Reset Password',
            ),
            color: Colors.lightBlue,
          ),
        ],
      ),
    );
  }
}