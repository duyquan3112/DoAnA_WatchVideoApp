import 'package:do_an/pages/homePage.dart';
import 'package:do_an/pages/signUpPage.dart';
import 'package:do_an/widgets/auth_button.dart';
import 'package:do_an/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class signInPage extends StatefulWidget {
  const signInPage({super.key});

  @override
  State<signInPage> createState() => _signInPageState();
}

class _signInPageState extends State<signInPage> {

  ///Get Input Data
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text,
      );
    
    ///Pop off loading circle
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomeApp()),
      );
    } on FirebaseAuthException catch (e) {
      ///Pop off loading circle
      Navigator.pop(context);
      if (e.code == 'user-not-found'){
        // wrongEmailPopup();
        print(e);
      } else if (e.code == 'wrong-password') {
        // wrongPasswordPopup();
        print(e);
      }
    }
  }
  
  //Navigate Function
  void navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomeApp()),
    );
  }

  void navigateToSignUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => signUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
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
                'Welcome back!!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'You have been missed!!!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 5),

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

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // sign in button
              // authButton(
              //   options: "Sign In",
              //   onTap: signUserIn,
              // ),
              GestureDetector(
                onTap: signUserIn,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
        
                  child: Center(
                    child: Text(
                      'Sign In',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
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
            
              // Navigate to Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member ?',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              //Continue as Guest
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Or continue using as',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: navigateToHomePage,
                    child: const Text(
                      'Guest',
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
    );
  }
}