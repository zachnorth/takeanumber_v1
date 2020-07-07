import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:takeanumberv1/models/user.dart';
import 'package:takeanumberv1/services/database.dart';
import 'package:takeanumberv1/shared/loading.dart';
import 'package:provider/provider.dart';

class CurrentLine extends StatefulWidget {

  final lineNumber;

  CurrentLine({ this.lineNumber });

  @override
  _CurrentLineState createState() => _CurrentLineState(lineNumber: lineNumber);
}

class _CurrentLineState extends State<CurrentLine> {

  final lineNumber;

  _CurrentLineState({ this.lineNumber });

  @override
  Widget build(BuildContext context) {

    final CollectionReference _line = Firestore.instance.collection('lines').document(widget.lineNumber).collection('line');

    final CollectionReference _users = Firestore.instance.collection('users');

    Future alertUser(String uid, bool change) async {
      await _line.document(uid).updateData({
        'ready': !change
      });
    }

    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    final user = Provider.of<User>(context);

    print('Line Number: ${widget.lineNumber}');

    String uidToDelete;


    //SnackBar Section


    final GlobalKey<ScaffoldState> _scaffKey = GlobalKey<ScaffoldState>();

    final snackbar = SnackBar(
      backgroundColor: Colors.orange[300],
      content: Row(
        children: <Widget>[
          Expanded(child: Text('Are you sure?', style: TextStyle(fontSize: 20.0, color: Colors.white))),
          SizedBox(width: 10.0),
          Expanded(child: MaterialButton(
            height: 40,
            minWidth: 120,
            child: Icon(Icons.check),
            onPressed: () async {
              await DatabaseService(uid: user.uid).deleteUserFromLine(lineNumber, uidToDelete);
              Navigator.of(context).pop();
            },
          )),
          Expanded(child: MaterialButton(
            height: 40,
            minWidth: 120,
            child: Icon(Icons.cancel),
            onPressed: () => _scaffKey.currentState.hideCurrentSnackBar(),
          ))
        ],
      ),
    );



    return StreamBuilder<QuerySnapshot>(
      stream: _line.orderBy('Date').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting : return new Loading();
          default:

            return Scaffold(
              backgroundColor: Colors.orange[200],
              key: _scaffKey,
              body: ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {

                  bool colorCheck = document['ready'];

                  user.myQueue.add(document['uid']);
                  /*
                  _users.document(user.uid)
                      .collection('queue')
                      .document(document.data['uid'])
                      .setData({
                        'uid': document.data['uid'],
                        'Date' : document.data['Date']
                      });
                   */


                  return Column(
                    children: <Widget>[
                      SizedBox(height: 2.0),
                      Container(
                        decoration: BoxDecoration(
                            color: !colorCheck ? Colors.red[200] : Colors.green[300],
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(
                                color: Colors.black,
                                width: 1
                            )
                        ),
                        child: new ListTile(
                          enabled: true,
                          title: Text('${document['position']}', style: TextStyle(fontSize: 20.0, color: Colors.black)),
                          onTap: () {
                            alertUser(document['position'], document['ready']);
                          },
                          onLongPress: () {
                            uidToDelete = document['uid'];
                            _scaffKey.currentState.showSnackBar(snackbar);
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
        }
      },
    );
  }
}
