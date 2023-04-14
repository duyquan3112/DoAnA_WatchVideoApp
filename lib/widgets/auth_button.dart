import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class authButton extends StatelessWidget {
  final Function()? onTap;
  final String options;

  const authButton({
    super.key, 
    required this.onTap,
    required this.options});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        
        child: Center(
          child: Text(
            options,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}