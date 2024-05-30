import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sName;
  final void Function()? onPressed;
  const MyTextBox(
      {super.key,
      required this.text,
      required this.sName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(7)),
      padding: const EdgeInsets.only(
        left: 15,
        right: 5,
        bottom: 15,
      ),
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Section name
              Text(
                sName,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),

              // edit btn
              IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.settings,
                    color: Colors.grey[400],
                  ))
            ],
          ),

          //text
          Text(text),
        ],
      ),
    );
  }
}
