import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/authenticate/register.dart';
import 'package:flutter_application_2/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIN = true;
  void toggleView(){
    setState(()=> showSignIN = !showSignIN);
    }
  @override
  Widget build(BuildContext context) {
  if (showSignIN ){
    return SignIn(toggleView: toggleView);
  }else{
    return Register(toggleView: toggleView);
  }
    }
}


