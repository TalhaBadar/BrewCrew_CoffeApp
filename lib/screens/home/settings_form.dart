import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/myuser.dart';
import 'package:flutter_application_2/services/database.dart';
import 'package:flutter_application_2/shared/loading.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  
  final _formKey= GlobalKey<FormState>();
  final List<String> sugars = ['0','1','2','3','4'];
  
  //form values
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;
  @override
  Widget build(BuildContext context) {
   final user = Provider.of<MyUser?>(context);
   
    return StreamBuilder<UserData>(
      stream: DatabaseService(
         uid: user!.uid).userData,
      builder: (context, snapshot){
        if (snapshot.hasData) {
          UserData? userData = snapshot.data;

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const Text(
                    'Update your Brew settings',
                    style: TextStyle(fontSize: 18.0,
                    fontFamily: 'Cyberpunk',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    ),
                  ),
                  const SizedBox(height:30.0),
                  TextFormField(
                    cursorColor: Colors.brown[800],
                   
                    initialValue: userData!.name,
                    decoration: InputDecoration(
                              hintStyle: const TextStyle(color: Colors.white),
                              fillColor: Colors.black54,
                              
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    const BorderSide(color: Colors.black, width: 3.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    const BorderSide(color: Colors.white, width: 3.0),
                              ),
                            ),
                            style: const TextStyle(
                              fontFamily: 'Cyberpunk',
                              color: Colors.white,
                            ),
                    validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) =>setState(()=> _currentName = val),
                  ),
                  const SizedBox(height: 30.0,),
                  //dropdown
                  DropdownButtonFormField(
                    dropdownColor: Colors.black,
                    focusColor: Colors.grey[900],
                    decoration: InputDecoration(
                              
                              hintStyle: const TextStyle(color: Colors.white),
                              fillColor: Colors.black54,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    const BorderSide(color: Colors.black, width: 3.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                              
                              borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    const BorderSide(color: Colors.white, width: 2.0),
                                    
                              ),
                            ),
                            
                            style: const TextStyle(
                              fontFamily: 'Cyberpunk',
                              color: Colors.white,
                            ),
                    value: _currentSugars?? userData.sugars,
                    items: sugars.map((sugar){
                      return DropdownMenuItem(
                        
                        value: sugar,
                        child: Text(
                          sugar == '1' ? '$sugar sugar':'$sugar sugars',
                          style: const TextStyle(
                            color: Colors.white,
                          ), 
                          ),
                      
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentSugars = val as String),
                    ),
                    const SizedBox(height: 40.0,),
                  //slider
                  Slider(
                    value: (_currentStrength?? userData.strength)!.toDouble(),
                    activeColor: Colors.brown[_currentStrength?? userData.strength!],
                    inactiveColor: Colors.brown[_currentStrength?? userData.strength!],
                    min: 100.0,
                    max: 900.0,
                    divisions: 8,
                    onChanged: (val) => setState(()=> _currentStrength= val.round()) , 
                    ),
                    const SizedBox(height: 25.0),
                  ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shadowColor: Colors.black,
                        elevation: 10
                        ),
                    child:  Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cyberpunk',
                        shadows: [
                Shadow(
                  // bottomLeft
                  offset: const Offset(-1.5, -1.5),
                  color: Colors.black.withOpacity(0.5),
                ),
                Shadow(
                  // bottomRight
                  offset: const Offset(1.5, -1.5),
                  color: Colors.black.withOpacity(0.5),
                ),
                Shadow(
                  // topRight
                  offset: const Offset(1.5, 1.5),
                  color: Colors.black.withOpacity(0.5),
                ),
                Shadow(
                  // topLeft
                  offset: const Offset(-1.5, 1.5),
                  color: Colors.black.withOpacity(0.5),
                ),
              ],
                        )
                      ),
                      onPressed: () async{
                        if(_formKey.currentState!.validate()){
                          await DatabaseService(uid: user.uid).updateUserData(
                            _currentSugars?? userData.sugars!,
                             _currentName?? userData.name!,
                             _currentStrength?? userData.strength!
                             );
                             Navigator.pop(context);
                       }
                        },
                      ),
                      const SizedBox(height: 10.0),
                ],
              ),
            ),
          );
          } else {
          return  const Loading();
        }
      }
    );
  }
}