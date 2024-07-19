import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/models/myuser.dart';
import 'package:flutter_application_2/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on FirebaseUser
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser( uid: user.uid) : null;
  }

  Stream<MyUser?> get user{
    return _auth.authStateChanges().map(_userFromFirebaseUser);
    //.map((User? user)=> _userFromFirebaseUser(user!));
    
  }

//sign in anonymously
  Future signInAnon() async {
    try {
    UserCredential result = await _auth.signInAnonymously();
    User user = result.user!;
    return _userFromFirebaseUser(user);
  } 
  catch(error){
    print (error.toString());
    return null;
  }
}

// sign in with email &password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
    UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    User user = result.user!;
    return user;
    }
    catch(error){
      print(error.toString());
      return null;  
    }
  }

// register with email &password
  Future createUserWithEmailAndPassword(String email, String password) async {
    try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;

    //create a new document for the new user with uid
    await DatabaseService(uid: user!.uid).updateUserData('0','new crew member',100);
    return _userFromFirebaseUser(user);
    }
    catch(error){
      print(error.toString());
      return null;  
    }
  }

//signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } 
    catch (error) {
      print(error.toString());
      return null;
      }
  }
}