import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthImplementation
{
Future<String> loginUser(String email, String password);
Future<String> newUser(String email, String password);
Future<String> getCurrentUser();
Future<void> logOut();

}

class Auth implements AuthImplementation
{
  final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;

  Future<String> loginUser(String email, String password) async
  {
    FirebaseUser user=await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }


  Future<String> newUser(String email, String password) async
  {
    FirebaseUser user=await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> getCurrentUser() async
  {
      FirebaseUser user=await _firebaseAuth.currentUser();
      return user.uid;
  }


  Future<void> logOut() async
  {
    _firebaseAuth.signOut();
  }
}