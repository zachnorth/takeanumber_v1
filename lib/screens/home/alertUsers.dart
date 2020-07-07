import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:takeanumberv1/models/user.dart';
import 'package:takeanumberv1/services/database.dart';
import 'package:takeanumberv1/shared/loading.dart';

class AlertUsers extends StatefulWidget {

  final String lineNumber;

  AlertUsers({ this.lineNumber });


  @override
  _AlertUsersState createState() => _AlertUsersState();
}

class _AlertUsersState extends State<AlertUsers> {



  final String lineNumber;

  _AlertUsersState({ this.lineNumber });



  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int numberUsersToAlert = 1;

  @override
  Widget build(BuildContext context) {
    
    
    final user = Provider.of<User>(context);

    final CollectionReference _currentLine = Firestore.instance.collection('lines');

    final CollectionReference _users = Firestore.instance.collection('users');

    Future alertUser(String uid, bool change, String lineNumber) async {
      await _currentLine.document(lineNumber).collection('line').document(uid).updateData({
        'ready': !change
      });
    }


    return StreamBuilder<QuerySnapshot>(
      stream: _currentLine.document(lineNumber).collection('line').orderBy('Date').doc.snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting :
            return Loading();
          default:
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              TextFormField(
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'How Many Users',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.teal, width: 2.0),
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() =>
                                  numberUsersToAlert = int.parse(val));
                                },
                              ),
                              SizedBox(height: 10.0),
                              RaisedButton(
                                color: Colors.green[300],
                                child: Text('Submit', style: TextStyle(
                                    fontSize: 20.0, color: Colors.black)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.green[300])
                                ),
                                onPressed: () {
                                  
                                  alertUser(uid, change, lineNumber)
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
        }
      },
    );
  }
}
