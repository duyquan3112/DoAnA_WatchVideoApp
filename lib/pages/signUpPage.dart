import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an/pages/signInPage.dart';
import 'package:do_an/widgets/auth_button.dart';
import 'package:do_an/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {

  ///Text Controller
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();


  //SignUp User
  void signUserUp() async {
    ///Create User 
    try {
      if (passwordConfirm()) {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text,
        );
        
        // String defaultAvatarUrl = 'assets/images/default.jpg';
        User user = userCredential.user!;
        await user.updateDisplayName('${firstnameController.text} ${lastnameController.text}');
        // await user.updatePhotoURL(defaultAvatarUrl);

        ///Store User data from signup to Firestore
        FirebaseFirestore.instance.collection('users').add({
        'lastName' : lastnameController.text,
        'firstName' : firstnameController.text,
        'username': usernameController.text,
        'email': emailController.text,
        'password' : passwordController.text,
        // 'avatarUrl': defaultAvatarUrl,
        });
      } else {
        Navigator.pop(context);
        // return Passnotsame();
      }

    
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found'){
        // wrongEmailPopup();
        print(e);
      } else if (e.code == 'wrong-password') {
        // wrongPasswordPopup();
        print(e);
      }
    }
  }

  /// Check password and confirm pass is same
  bool passwordConfirm() {
    if (passwordController.text == confirmPasswordController.text){
      return true;
    } else {
      return false; 
    }
  }

  //Navigate to SignIn
  void navigateToSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => signInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                const SizedBox(height: 0),
      
                // Logo App
                const Icon(
                  Icons.lock,
                  size: 50,
                ),
      
                const SizedBox(height: 5),
      
                // Welcome Text
                Text(
                  'Let\'s create new account!!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      
                const SizedBox(height: 5),
      
                //Username
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
      
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: 
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: firstnameController,
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintText: 'First Name',
                              hintStyle: TextStyle(color: Colors.grey[500])
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: lastnameController,
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade400),
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintText: 'Last Name',
                              hintStyle: TextStyle(color: Colors.grey[500])
                            ),
                          ),
                        ),
                      ]
                    ),
                ),

                const SizedBox(height: 10),
      
                // Emailname textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,               
                ),
      
                const SizedBox(height: 10),
                // password textfield
                
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,               
                ),
      
                const SizedBox(height: 10),
      
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,               
                ),
      
                const SizedBox(height: 20),
      
                // sign in button
                authButton(
                  options: "Sign up",
                  onTap: signUserUp, 
                ),
      
                const SizedBox(height: 15),
      
                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 15),
        
                // continue with gg apple
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // google button
                    // SquareTile(imagePath: 'assets/images/google.png'),
                    SizedBox(width: 25),
                  ],
                ),
      
                const SizedBox(height: 15),
              
              
                // register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account ?',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: navigateToSignIn,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}