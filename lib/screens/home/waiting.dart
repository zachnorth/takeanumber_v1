import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takeanumberv1/models/user.dart';
import 'package:takeanumberv1/services/auth.dart';
import 'package:takeanumberv1/shared/loading.dart';

class Waiting extends StatefulWidget {

  final int position;
  final String lineNumber;

  Waiting({ this.position, this.lineNumber });

  @override
  _WaitingState createState() => _WaitingState(position: position, lineNumber: lineNumber);
}

class _WaitingState extends State<Waiting> {

  final int position;
  final String lineNumber;
  _WaitingState({ this.position, this.lineNumber });




  final AuthService _auth = AuthService();


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    print(lineNumber);

    final DocumentReference stillWaiting = Firestore.instance.collection('lines').document(lineNumber).collection('line').document(user.uid);

    return StreamBuilder<DocumentSnapshot>(
      stream: stillWaiting.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting :
            return new Loading();
          default:
            print(snapshot.data['ready']);
            return Scaffold(
              backgroundColor: !snapshot.data['ready'] ? Colors.red[200] : Colors.lightGreen[200],
              appBar: AppBar(
                backgroundColor: Colors.orange[200],
                title: Text('Waiting Page', style: TextStyle(fontSize: 20.0, color: Colors.black)),
                actions: <Widget>[
                  FlatButton.icon(
                    icon: Icon(Icons.arrow_back),
                    label: Text(''),
                    onPressed: () {
                      _auth.signOut();
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
              body: Container(
                width: 400.0,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 180),
                    Text(
                      '# ${position.toString()}',
                      style: TextStyle(fontSize: 120, color: Colors.grey[800]),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: !snapshot.data['ready'] ? 200.0 : 320.0,
                      child: Text(
                        !snapshot.data['ready'] ? 'Please Wait...' : 'Your # has been called',
                        style: TextStyle(fontSize: 30.0, color: Colors.grey[800]),
                      ),
                    )
                  ],
                ),
              ),
            );
        }
      }
    );
  }
}
