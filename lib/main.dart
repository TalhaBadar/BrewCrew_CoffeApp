import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_2/models/brew.dart';
import 'package:flutter_application_2/models/myuser.dart';
import 'package:flutter_application_2/screens/wrapper.dart';
import 'package:flutter_application_2/services/auth.dart';
import 'package:flutter_application_2/services/database.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<MyUser?>.value(
          catchError: (context, error) => null,
          value: AuthService().user,
          initialData: null,
        ),
        StreamProvider<List<Brew?>?>.value(
          catchError: (context, error) => null,
          value: DatabaseService(uid: '').brews,
          initialData: null,
        ),
      ],
      child: const MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}