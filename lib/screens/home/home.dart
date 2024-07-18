import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/brew.dart';
import 'package:flutter_application_2/models/myuser.dart';
import 'package:flutter_application_2/screens/home/brew_list.dart';
import 'package:flutter_application_2/services/auth.dart';
import 'package:flutter_application_2/services/database.dart';
import 'package:provider/provider.dart';


class Home extends StatelessWidget {
   Home({super.key});
  final AuthService _auth= AuthService();
  @override
  Widget build(BuildContext context) {
     final user = Provider.of<MyUser?>(context);

    return StreamProvider<List<Brew?>?>.value(
      value: user != null ? DatabaseService(uid: user.uid!).brews : const Stream<List<Brew>>.empty(),
      initialData: null,
      child: Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text('Brew Crew'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label:const Text('Logout'),
            onPressed: () async{
              await _auth.signOut();
            },
             )
          ],
    ),
    body:  BrewList(),
    ),
    );
  }
}