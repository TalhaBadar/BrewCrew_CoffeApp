import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/models/myuser.dart';
import 'package:flutter_application_2/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on FirebaseUser
  MyUser? _userFromFirebaseUser(User user) {
    // ignore: unnecessary_null_comparison
    return user != null ? MyUser( uid: user.uid) : null;
  }

  Stream<MyUser?> get user{
    return _auth.authStateChanges()
    .map((User? user)=> _userFromFirebaseUser(user!));
    
  }

//sign in anonymously
  Future signInAnon() async {
    try {
    UserCredential result = await _auth.signInAnonymously();
    User? user = result.user;
    return _userFromFirebaseUser(user!);
  } 
  catch(e){
    print (e.toString());
    return null;
  }
}

// sign in wiht email &password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
    UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
     // Check and create Firestore document if it doesn't exist
    await DatabaseService(uid: user!.uid).checkAndCreateUserData();

    return _userFromFirebaseUser(user);

    
    }
    catch(e){
      print(e.toString());
      return null;  
    }
  }

// register with email &password
  Future creatUserWithEmailAndPassword(String email, String password) async {
    try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;

    //create a new document for the new user with uid
    await DatabaseService(uid: user!.uid).updateUserData('0','new crew member',100);
    return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;  
    }
  }

//signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } 
    catch (e) {
      print (e.toString());
      return null;
      }
  }
}