import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Waiting extends StatefulWidget {
  @override
  _WaitingState createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: Text('Waiting Page', style: TextStyle(fontSize: 20.0, color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          Text(
            'Please wait for your number to be called...',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
