import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takeanumberv1/services/auth.dart';
import 'package:takeanumberv1/services/database.dart';
import 'package:takeanumberv1/models/user.dart';
import 'package:takeanumberv1/screens/home/waiting.dart';

class JoinLineHome extends StatefulWidget {
  @override
  _JoinLineHomeState createState() => _JoinLineHomeState();
}

class _JoinLineHomeState extends State<JoinLineHome> {

  
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[200],
      appBar: AppBar(
        title: Text('Take A Number', style: TextStyle(fontSize: 20.0, color: Colors.black)),
        backgroundColor: Colors.orange[200],
      ),
      body: MyCustomForm()
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final myController = TextEditingController();
    final user = Provider.of<User>(context);

    int nextNumber;

    return Container(
      width: 400.0,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300.0,
              child: TextFormField(
                controller: myController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else if(value.length < 1) {
                    return 'Line numbers must be exactly 6 digits';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter Line Number...',
                ),
              ),
            ),
            SizedBox(height: 20.0),
            MaterialButton(
              height: 40.0,
              minWidth: 120.0,
              color: Colors.green[300],
              child: Text('Submit', style: TextStyle(fontSize: 20.0, color: Colors.black)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.green[300])
              ),
              onPressed: () async {
                nextNumber = await _joinLineHelper(myController.text);
                setState(() {
                  nextNumber = nextNumber;
                });
                _waitingHelper(context, nextNumber, myController.text);
              },
            )
          ],
        ),
      ),
    );
  }

  Future<int> _joinLineHelper(String lineName) async {

    int nextNumber;

    dynamic result = await _auth.signInAnon();

    if(result == null) {
      print('Error Signing In');
      return null;
    } else {
      print('Signed In Anonymously');
      print('${result.uid}');

      nextNumber = await DatabaseService(uid: result.uid).joinLine(lineName, result.uid);

      return nextNumber;
    }
  }

  void _waitingHelper(BuildContext context, int nextNumber, String lineNumber) {
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return StreamProvider<User>.value(
                  value: AuthService().anonUser,
                  child: Scaffold(
                    body: Waiting(position: nextNumber, lineNumber: lineNumber),
                  )
              );
            }
        )
    );
  }
}