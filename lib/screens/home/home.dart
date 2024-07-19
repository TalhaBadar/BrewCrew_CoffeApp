import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/brew.dart';
import 'package:flutter_application_2/screens/home/brew_list.dart';
import 'package:flutter_application_2/screens/home/settings_form.dart';
import 'package:flutter_application_2/services/auth.dart';
import 'package:flutter_application_2/services/database.dart';
import 'package:provider/provider.dart';


class Home extends StatelessWidget {

  final AuthService _auth= AuthService();

  Home({super.key});
  @override
  Widget build(BuildContext context) {

    void showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: const SettingsForm(

          ),
        );
    });
    }


    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
       initialData: const [],
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
            ),
            TextButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text('Settings'),
              onPressed: ()=>showSettingsPanel(),
                
            )

          ],
    ),
    body:  const BrewList(),
    ),
    );
  }
}