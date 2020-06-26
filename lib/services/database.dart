import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:takeanumberv1/models/line.dart';
import 'package:takeanumberv1/models/user.dart';


class DatabaseService {

  final String uid;
  final String lineName;
  DatabaseService({ this.uid, this.lineName });

  //collection reference
  final CollectionReference currentLines = Firestore.instance.collection('lines');


  //  ******** Current functions *******

  Future createNewLine(String name) async {     //"String name" is the variable that should hold the unique identifier for the store itself (6 character code)

    return await currentLines.document(name).setData({
      'name': name,
      'startTime': DateTime.now(),
      'nextNumber': 1,
      'currentlyHelping': 1
    });

  }

  Future deleteCurrentLine(String uid) async {

    await currentLines.document(uid).delete();

    dynamic result = await currentLines.document(uid).get();
    if(!result.exists) {
      return 'Line Deleted Successfully';
    } else {
      print('Line could not be deleted');
    }

  }

  Future<bool> checkIfLineNumberAvailable(String ruid) async {

    bool check = false;

    await currentLines.document(ruid).get().then((doc) {
      if(doc.exists) {
        check = true;
      }
    });
    return check;
  }


  Future<int> joinLine(String lineName, String uid) async {

    int nextNumber;

    dynamic result = await currentLines.document(lineName)
        .collection('line')
        .document(uid)
        .get();
    if (!result.exists) {
      DocumentSnapshot snapshot = await currentLines.document(lineName).get();
      nextNumber = snapshot.data['nextNumber'];

      print('Next Number: $nextNumber');

      await currentLines.document(lineName).collection('line').document(
          uid).setData({
        'uid': uid,
        'Date': DateTime.now(),
        'position': nextNumber,
        'ready': false
      });

      await currentLines.document(lineName).setData({ 'nextNumber': nextNumber + 1, 'startTime': snapshot.data['startTime'] });

      print('Here: $nextNumber');

      return nextNumber;
    } else {
      DocumentSnapshot snapshot = result;
      return snapshot.data['position'];
    }
  }



  Future deleteUserFromLine(String lineNumber, String uid) async {

    await currentLines.document(lineNumber).collection('line').document(uid).delete();

    dynamic result = await currentLines.document(lineNumber).collection('line').document(uid).get();

    if(!result.exists) {
      print('Line Successfully Deleted.');
    } else {
      print('Line Did Not Delete.');
    }
  }




  // ******** Current Functions *********


  Future updateUserData(String sugars, String name, int strength) async {
    //Potentially where i have to look up stores by a name (uid)
    //pass storeName to .document(storeName) to create a new line with the document name storeName
    return await currentLines.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  Future addUserToExistingLine(String storeName, String userName, String uid) async {

    dynamic result = await currentLines.document(storeName).collection('line').document(userName).get();
    if(!result.exists) {
      return await currentLines.document(storeName).collection('line').document(userName).setData({
        'name': userName,
        'time': DateTime.now(),
        'uid': uid
      });
    } else {
      print('User $userName Already exists');
    }

  }

  //list list from snapshot
  List<Line> _lineListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Line(
        name: doc.data['name'] ?? '',
        sugars: doc.data['sugars'] ?? '0',
        strength: doc.data['strength'] ?? 0,
      );
    }).toList();
  }

  //user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data['name'],
        sugars: snapshot.data['sugars'],
        strength: snapshot.data['strength']
    );
  }

  //get lines stream
  Stream<List<Line>> get lines {
    return currentLines.snapshots()
        .map(_lineListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return currentLines.document(uid).snapshots()
        .map(_userDataFromSnapshot);
  }



}