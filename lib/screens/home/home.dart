import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:takeanumberv1/services/auth.dart';
import 'dart:collection';
import 'package:takeanumberv1/services/database.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:takeanumberv1/models/user.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();
  final CollectionReference currentLines = Firestore.instance.collection('lines');

  Queue myQueue = Queue();

  var random = Random();

  String ruid = '';


  @override
  Widget build(BuildContext context) {


    var line = Provider.of<List<Person>>(context);

    myQueue.add(line);

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.tealAccent,
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
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 40.0),
            MaterialButton(
              height: 70.0,
              minWidth: 170.0,
              color: Colors.green,
              child: Text('Start New Line',
                  style: TextStyle(color: Colors.white, fontSize: 20.0)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.blueGrey)
              ),
              onPressed: () {
                ruid = _randomNumberGeneratorHelper();
                _startNewLine(ruid);
              },
            ),
            SizedBox(height: 20.0),
            MaterialButton(
              height: 70.0,
              minWidth: 170.0,
              color: Colors.redAccent,
              child: Text('End Current Line',
                  style: TextStyle(color: Colors.white, fontSize: 20.0)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.blueGrey)
              ),
              onPressed: () => _deleteCurrentLine(ruid),
            ),
            MaterialButton(
              height: 70.0,
              minWidth: 170.0,
              color: Colors.amber,
              child: Text('Show current line members', style: TextStyle(fontSize: 20.0, color: Colors.white)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.blueGrey)
              ),
              onPressed: () {
                myQueue.forEach((i) => print(i));
              },
            ),
            Expanded(child: Container()),
            Container(
                child: Text('Current Line Number: $ruid',
                    style: TextStyle(color: Colors.white, fontSize: 28.0))
            )
          ],
        ),
      ),
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
        ruid = ruid;
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


