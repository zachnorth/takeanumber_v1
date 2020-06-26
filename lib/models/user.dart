import 'dart:collection';

class User {

  final String uid;

  User({ this.uid });

  Queue myQueue = Queue();

}

class AnonUser {

  final String uid;

  AnonUser({ this.uid });
}

class UserData {

  //potential stream to know how many people currently in line
  //final int numberPeopleInLine;
  final String uid;
  final String name;
  final String sugars;
  final int strength;

  UserData({ this.uid, this.name, this.sugars, this.strength });

}


class Person {

  final String uid;
  final String date;

  Person({this.uid, this.date});

  Person.fromJson(Map<String, dynamic> parsedJson)
  : uid = parsedJson['name'],
    date = parsedJson['date'];
}