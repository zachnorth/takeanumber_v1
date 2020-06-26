import 'package:css_colors/css_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takeanumberv1/services/auth.dart';
import 'package:takeanumberv1/models/user.dart';
import 'package:takeanumberv1/screens/wrapper.dart';
import 'package:takeanumberv1/screens/home/joinLineHome.dart';
import 'package:takeanumberv1/services/firestore_service.dart';
import 'package:takeanumberv1/shared/constants.dart';
import 'package:takeanumberv1/shared/loading.dart';




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
        backgroundColor: Colors.lightGreen[200],
        appBar: AppBar(
          title: Text(widget.title, style: textStyling.copyWith(color: Colors.black)),
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                height: 70.0,
                minWidth: 170,
                elevation: 8.0,
                color: Colors.green[300],
                child: Text('Login', style: textStyling.copyWith(color: Colors.black)),
                onPressed: () => _wrapperHelper(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.green[300])
                ),

              ),
              SizedBox(height: 80.0),
              MaterialButton(
                height: 70.0,
                minWidth: 170,
                elevation: 8.0,
                color: Colors.orange[200],
                child: Text('Take A Number', style: textStyling.copyWith(color: Colors.black)),
                onPressed: () {
                  _auth.signInAnon();
                  _joinLineWrapper(context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.orange[200])
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  void _colorHelper(BuildContext context) {

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {

          return Scaffold(
            backgroundColor: Colors.lightGreen[200],
            appBar: AppBar(
              elevation: 4.0,
              title: Text('Colors Helper', style: TextStyle(fontSize: 20.0, color: Colors.black)),
              backgroundColor: Colors.orange[200],
            ),

            body: Container(
              width: 400.0,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 40.0),
                  MaterialButton(
                    height: 70.0,
                    minWidth: 170.0,
                    elevation: 8.0,
                    child: Text('Test Button', style: TextStyle(fontSize: 20.0, color: Colors.black)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.lime[200])
                    ),
                    color: Colors.lime[200],
                    onPressed: () {},
                  )
                ],
              ),
            ),
          );
        }
      )
    );
  }

  void _loadingHelper(BuildContext context) {

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.blueGrey,
            appBar: AppBar(
              title: Text('Loading Helper', style: textStyling),
              backgroundColor: Colors.tealAccent,
              actions: <Widget>[
                FlatButton.icon(
                  label: Text(''),
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
            body: Loading(),
          );
        }
      )
    );

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
                child: Scaffold(
                  body: JoinLineHome(),
                ),
              );
            }
        )
    );
  }
