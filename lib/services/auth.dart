import 'package:e_voting_frontend/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference voter = Firestore.instance.collection('voters');
  //create user obj based on Firebase User
  User _userFromFirebaseUser(FirebaseUser user){
        return User(uid: user.uid);
  }

  //auth change user stream
  Stream<User>? get loginUser {
    if (_auth.onAuthStateChanged.map(_userFromFirebaseUser) != null) {
      return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
    }
    return null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null){
        if (Firestore.instance.collection('voters')
            .where("email", isEqualTo: email).snapshots() != null){
          print(Firestore.instance.collection('voters')
              .where("email", isEqualTo: email).snapshots());
          FirebaseUser user = result.user;
          return _userFromFirebaseUser(user);
        }
        else{
          return;
        }
      }

    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //signout
  Future signOut() async{
    print("signout function ");
    return  await _auth.signOut();
    try{
      return  await _auth.signOut();
    } catch(e){
      print("note signing out");
      print(e.toString());
      return null;
    }
  }
}