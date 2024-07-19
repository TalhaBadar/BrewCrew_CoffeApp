import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/brew.dart';
import 'package:flutter_application_2/screens/home/brew_list.dart';
import 'package:flutter_application_2/screens/home/settings_form.dart';
import 'package:flutter_application_2/services/auth.dart';
import 'package:flutter_application_2/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    void showSettingsPanel() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        backgroundColor: const Color.fromARGB(238, 121, 95, 72),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            
            child: const SettingsForm(),
          );
        },
      );
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      initialData: const [],
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: const Text(
            'Brew Crew',
            style: TextStyle(
              fontFamily: 'Cyberpunk',
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onSelected: (value) async {
                if (value == 'logout') {
                  await _auth.signOut();
                } else if (value == 'Update') {
                  showSettingsPanel();
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'Update',
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Row(
                        children: <Widget>[
                          Icon(Icons.edit, color: Colors.black),
                          SizedBox(width: 8.0),
                          Text('Update my brew'),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Row(
                        children: <Widget>[
                          Icon(Icons.logout, color: Colors.black),
                          SizedBox(width: 8.0),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/coffee_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Column(
              children: <Widget>[
                Expanded(child: BrewList()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
