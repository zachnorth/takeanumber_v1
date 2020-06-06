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
      appBar: AppBar(
        title: Text('Take A Number'),
        backgroundColor: Colors.teal[400],
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

    return Form(
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                _joinLineHelper(myController.text);
                _waitingHelper(context);
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  void _joinLineHelper(String lineName) async {

    dynamic result = await _auth.signInAnon();

    if(result == null) {
      print('Error Signing In');
    } else {
      print('Signed In Anonymously');
      print(result.uid);

      await DatabaseService(uid: result.uid).joinLine(lineName, result.uid);
    }
  }

  void _waitingHelper(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return StreamProvider<User>.value(
                  value: AuthService().user,
                  child: MaterialApp(
                    home: Waiting(),
                  )
              );
            }
        )
    );
  }
}