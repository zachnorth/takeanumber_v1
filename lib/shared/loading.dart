import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightGreen[200],
      child: Center(
        child: SpinKitFadingFour(
          color: Colors.purple[400],
          size: 80.0,
        ),
      ),
    );
  }
}
