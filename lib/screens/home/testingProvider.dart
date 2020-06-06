import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takeanumberv1/models/user.dart';

class ProviderTest extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    var reports = Provider.of<List<Person>>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Provider Test Page'),
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
         Person person = reports[index];
          return ListTile(
            leading: Text(person.uid),
            title: Text(person.uid),
            trailing: Text(person.date),
          );
        },
      ),
    );
  }
}
