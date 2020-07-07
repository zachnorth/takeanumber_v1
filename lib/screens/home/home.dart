import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:takeanumberv1/screens/home/alertUsers.dart';
import 'package:takeanumberv1/screens/home/currentLine.dart';
import 'package:takeanumberv1/services/auth.dart';
import 'package:takeanumberv1/services/database.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:takeanumberv1/models/user.dart';
import 'package:css_colors/css_colors.dart';
import 'package:takeanumberv1/shared/constants.dart';
import 'package:takeanumberv1/shared/loading.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GlobalKey<ScaffoldState> _scaffKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthService _auth = AuthService();
  final CollectionReference currentLines = Firestore.instance.collection('lines');
  final CollectionReference users = Firestore.instance.collection('users');


  var random = Random();

  String ruid = '';

  bool hasruid = false;

  String currentlyHelping;




  @override
  Widget build(BuildContext context) {

    String ruidToDelete;

    final user = Provider.of<User>(context);


    final snackbar1 = SnackBar(
      backgroundColor: Colors.teal[100],
      content: Text('You must end your current line before starting a new line.', style: TextStyle(fontSize: 16.0, color: Colors.black)),
    );

    final snackbar = SnackBar(
      backgroundColor: Colors.black,
      content: Row(
        children: <Widget>[
          Expanded(child: Text('Are you sure?', style: TextStyle(fontSize: 20.0, color: Colors.white))),
          SizedBox(width: 10.0),
          Expanded(child: MaterialButton(
            height: 40,
            minWidth: 120,
            child: Icon(Icons.check),
            onPressed: () async {
              _deleteCurrentLine(ruidToDelete);
              _scaffKey.currentState.hideCurrentSnackBar();
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



    return Scaffold(
      key: _scaffKey,
      backgroundColor: Colors.lightGreen[200],
      appBar: AppBar(
        title: Text('Home Page', style: TextStyle(fontSize: 20.0, color: Colors.black)),
        backgroundColor: Colors.orange[200],
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.arrow_back),
            label: Text('Log Out'),
            onPressed: () {
              _auth.signOut();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 40.0),
          MaterialButton(
            height: 70.0,
            minWidth: 170.0,
            color: Colors.green[300],
            child: Text('Start New Line',
                style: TextStyle(color: Colors.black, fontSize: 20.0)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.green[300])
            ),
            onPressed: () {
              if(!hasruid) {
                ruid = _randomNumberGeneratorHelper();
                _startNewLine(ruid);
                setState(() {
                  hasruid = true;
                });
              } else {
                _scaffKey.currentState.showSnackBar(snackbar1);
              }

              users.document(user.uid).updateData({ 'currentLineNumber': ruid });
            },
          ),
          SizedBox(height: 20.0),
          MaterialButton(
            height: 70.0,
            minWidth: 170.0,
            color: Colors.red[200],
            child: Text('End Current Line',
                style: TextStyle(color: Colors.black, fontSize: 20.0)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red[200])
            ),
            onPressed: () {
              if(hasruid) {
                ruidToDelete = ruid;
                hasruid = false;
                _scaffKey.currentState.showSnackBar(snackbar);
              }
            },
          ),
          SizedBox(height: 20.0),
          MaterialButton(
            height: 70.0,
            minWidth: 170.0,
            color: Colors.orange[200],
            child: Text('Show current line members', style: TextStyle(fontSize: 20.0, color: Colors.black)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.orange[200])
            ),
            onPressed: () {
              if(hasruid) {
                showModalBottomSheet(context: context, builder: (context) {
                  return Container(
                    color: Colors.orange[200],
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 80.0),
                    child: _currentLineHelper(context),
                  );
                });
              }
            },
          ),
          SizedBox(height: 20.0),
          MaterialButton(
            height: 70.0,
            minWidth: 170.0,
            color: Colors.orange[200],
            child: Text('Alert Next Numbers', style: TextStyle(fontSize: 20.0, color: Colors.black)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.orange[200])
            ),
            onPressed: () {
              if(hasruid) {
                showModalBottomSheet(context: context, builder: (context) {

                  return Container(
                    color: Colors.orange[200],
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 80.0),
                    child: _alertUsersHelper(context),
                  );
                });
              }
            },
          ),
          Expanded(child: Container()),
          Container(
              child: ruid == '' ? Text('') : StreamBuilder<DocumentSnapshot>(
                stream: currentLines.document(ruid).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if(snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return new Loading();
                    default:
                      return Text(
                        'Currently Helping: ${snapshot.data['currentlyHelping'].toString()}',
                        style: TextStyle(fontSize: 28.0, color: Colors.black),
                      );
                  }
                },
              )
          ),
          Container(
              child: Text('Current Line Number: $ruid',
                  style: TextStyle(color: Colors.black, fontSize: 28.0))
          )
        ],
      ),
    );
  }


  StreamProvider<User> _alertUsersHelper(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: AlertUsers(lineNumber: ruid),
    );
  }


  StreamProvider<User> _currentLineHelper(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user,
        child: CurrentLine(lineNumber: '10')
    );
  }

  Future<void> _startNewLine(String ruid) async {

    await _availabilityCheckHelper(ruid, 0);
  }

  void _deleteCurrentLine(String uid) async {
    print(uid);
    await DatabaseService(uid: uid).deleteCurrentLine(uid);
    setState(() {
      ruid = '';
    });
  }

  Future<void> _availabilityCheckHelper(String ruid, int count) async {


    bool check = await DatabaseService(uid: ruid).checkIfLineNumberAvailable(ruid);
    print('First $check');
    if (check && (count < 21)) {


      ruid = _randomNumberGeneratorHelper();
      print('Needed new line number: $ruid');
      count++;
      _availabilityCheckHelper(ruid, count);

    } else if (count >= 21) {

      print('Could Not Start Line. No Positions Available.');

    } else {

      print('No change to ruid: $ruid');
      DatabaseService(uid: ruid).createNewLine(ruid);
      setState(() {
        this.ruid = ruid;
      });

    }
  }

  String _randomNumberGeneratorHelper() {
    var random = Random();
    int max = 20;
    int min = 0;

    return (min + random.nextInt(max - min)).toString();
  }

  String _ruidFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.data['name'];
  }

  Stream<String> get queueData {
    return currentLines.document(ruid).snapshots()
        .map(_ruidFromSnapshot);
  }

}


