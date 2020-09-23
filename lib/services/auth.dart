import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/Users.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_firebase_app/model/users.dart';

class AuthMethods{

final FirebaseAuth _auth = FirebaseAuth.instance;

Users _userFromFirebaseUser(User user){
  return user!=null ?  Users(userId: user.uid): null;

}
Future signInWithEmailAndPassword(String email, String password)async{
  try{
    UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    User firebaseUser = result.user;
    return _userFromFirebaseUser(firebaseUser);
  }
  catch(e){
    Fluttertoast.showToast(
        msg:'Incorrect email or password! Please try again!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM_LEFT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black38,
        textColor: Colors.red[400],
        fontSize: 16.0
    );
  }
}
Future signUpWithEmailAndPassword(String email, String password) async{
  try{
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User firebaseUser= result.user;
    return _userFromFirebaseUser(firebaseUser);

  }
  catch(e)
  {
    print(e.toString());
  }
}

Future resetPassword(String email)async{
  try{
    return await _auth.sendPasswordResetEmail(email: email);

  }catch(e){
    print(e.toString());
  }
}

Future signOut() async{
  try{
    return await _auth.signOut();
  }catch(e)
  {
    print(e.toString());
  }
}
}