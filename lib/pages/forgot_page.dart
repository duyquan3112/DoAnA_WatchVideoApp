import 'package:do_an/widgets/error_SnackBar.dart';
import 'package:do_an/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'Không tìm thấy người dùng có địa chỉ email này';
      } else if (emailController.text.isEmpty) {
        errorMessage = 'Vui lòng nhập mail để tiến hành thay đổi mật khẩu';
      } else {
        errorMessage = 'Đã gửi link reset mật khẩu';
      }
      errorSnackBar(errMess: errorMessage).build(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        elevation: 0,
      ),
      body: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your Email and we will send you a password reset link!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // Emailname textfield
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),

            const SizedBox(
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
                color: const Color.fromARGB(255, 0, 0, 0),
                child: const Text(
                  'Reset Password',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
