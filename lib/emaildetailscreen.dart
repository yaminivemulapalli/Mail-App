import 'package:flutter/material.dart';

class Emaildetailscreen extends StatelessWidget {
  final String sender;
  final String content;
  const Emaildetailscreen(
      {super.key, required this.sender, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sender),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(content, style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
