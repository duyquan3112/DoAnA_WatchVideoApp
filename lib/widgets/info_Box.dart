import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class infoTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  const infoTextBox({
    required this.text,
    required this.sectionName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue[100],
        borderRadius: BorderRadius.circular(10.0)
      ),
      padding: EdgeInsets.only(
        left: 15.0,
        bottom: 15.0,
      ),
      margin: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(
                  color: Colors.black45,
                ),
              ),
              IconButton(
                onPressed: () {}, 
                icon: Icon(
                  Icons.edit,
                  color: Colors.black
                ),
              )
            ],
          ),
          Text(
            text,
          ),
        ],
      ),
    );
  }
}