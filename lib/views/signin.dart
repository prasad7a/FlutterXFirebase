import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/helper/HelperFunctions.dart';
import 'package:flutter_firebase_app/services/auth.dart';
import 'package:flutter_firebase_app/services/database.dart';
import 'package:flutter_firebase_app/views/ChatRoomScreen.dart';
import 'package:flutter_firebase_app/widgets/widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'forgotpwd.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  AuthMethods authMethods=new AuthMethods();
  final formKey = GlobalKey<FormState>();
  bool isLoading=false;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snapshotUserInfo;




  signIn() {  //Sign in function
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      //TODO function to get user details

      setState(() {
        isLoading = true;
      });

          databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
                  snapshotUserInfo = val;
                  HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.docs[0].data()['name']);
          });
      authMethods.signInWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
          ));
        }
      });
    }



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: appBarMain(context),
      body:
      SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 70,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Form(
                key: formKey,
                child: Column(children: [
                  TextFormField(
                    validator: (val) {
                      return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val) ? null : "Enter correct email";
                    },
                    controller: emailTextEditingController,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("email"),
                  ),
                  TextFormField(
                      validator: (val){
                        return val.length>6? null :'Please enter a password that is at least 6 characters long';
                      },

                    controller: passwordTextEditingController,
                    obscureText: true,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("password"),
                  ),
                ],),
              ),
                  SizedBox(height: 8.0,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()));
                    //AuthMethods().resetPassword(emailTextEditingController.text);
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text('Forgot Password',
                        style: TextStyle(color: Colors.white,
                            fontSize: 17.0,
                            decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0,),

                FlatButton(
                  onPressed: () {
                      signIn();
//
//
                  },

                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(gradient: LinearGradient(
                      colors: [
                        const Color(0xff007ef4),
                        const Color(0xff2A75BC),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text('Sign in',
                        style:
                        TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                    ),
                    ),
                  ),
                ),
                SizedBox(height:17.0),

//                Container(
//
//                  alignment: Alignment.center,
//                  width: MediaQuery.of(context).size.width,
//                  padding: EdgeInsets.all(20.0),
//                  decoration: BoxDecoration(
//                    color: Colors.white,
//                    borderRadius: BorderRadius.circular(30.0),
//                  ),
//                  child: Text('Sign in with Google',
//                    style:
//                    TextStyle(
//                      color: Colors.black87,
//                      fontSize: 17.0,
//                    ),
//                  ),
//                ),

                SizedBox(height:17.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Don't have an account? ",style: mediumTextStyle(),),
                  GestureDetector(

                    onTap: (){
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical:8.0),
                      child: Text("Register Now",style: TextStyle(color: Colors.white,
                        fontSize: 17.0,
                      decoration: TextDecoration.underline,
                      )
                        ,),
                    ),
                  ),
                  ],
                ),
                SizedBox(height:50.0),

              ],

            ),
          ),
        ),
      ),
    );
  }
}
