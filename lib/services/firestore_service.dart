import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:takeanumberv1/models/user.dart';

class FirestoreService {
  Firestore _db = Firestore.instance;
  var random = Random();
  
  Stream<List<Person>> getPerson() {
    return _db
        .collection('lines')
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.documents
        .map((document) => Person.fromJson(document.data))
        .toList());
  }


  Future<void> addPerson() {


    var dataMap = Map<String, dynamic>();
    dataMap['name'] = 'testName';
    dataMap['date'] = DateTime.now();


    return _db.collection('lines').add(dataMap);
  }

  int next(int min, int max) => min + random.nextInt(max - min);
}