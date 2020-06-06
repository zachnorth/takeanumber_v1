import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takeanumberv1/services/auth.dart';
import 'package:takeanumberv1/models/user.dart';
import 'package:takeanumberv1/screens/wrapper.dart';
import 'package:takeanumberv1/screens/home/joinLineHome.dart';
import 'package:takeanumberv1/services/firestore_service.dart';




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(title: 'Take A Number'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final AuthService _auth = AuthService();
  final FirestoreService _db = FirestoreService();

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        StreamProvider(create: (BuildContext context) => _db.getPerson())
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text(widget.title),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                height: 70.0,
                minWidth: 170,
                color: Colors.green[400],
                child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                onPressed: () => _wrapperHelper(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.grey[500])
                ),

              ),
              SizedBox(height: 20.0),
              MaterialButton(
                height: 70.0,
                minWidth: 170,
                color: Colors.green[500],
                child: Text('Take A Number', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                onPressed: () {
                  _auth.signInAnon();
                  _joinLineWrapper(context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.grey[500])
                ),

              )
            ],
          ),
        ),
      ),
    );
  }
}

  void _wrapperHelper(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return StreamProvider<User>.value(
                  value: AuthService().user,
                  child: MaterialApp(
                    home: Wrapper(),
                  )
              );
            }
        )
    );

  }


  void _joinLineWrapper(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return StreamProvider<User>.value(
                value: AuthService().anonUser,
                child: MaterialApp(
                  home: JoinLineHome(),
                ),
              );
            }
        )
    );
  }
