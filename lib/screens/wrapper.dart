import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/myuser.dart';
import 'package:flutter_application_2/screens/authenticate/authenticate.dart';
import 'package:flutter_application_2/screens/home/home.dart';
import 'package:provider/provider.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context); // get user from provider
    if (user == null){
      return const Authenticate();
    }
      else{
        return Home();
      }

  }
}