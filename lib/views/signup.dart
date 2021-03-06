import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/helper/HelperFunctions.dart';
import 'package:flutter_firebase_app/services/auth.dart';
import 'package:flutter_firebase_app/services/database.dart';
import 'package:flutter_firebase_app/views/ChatRoomScreen.dart';
import 'package:flutter_firebase_app/widgets/widget.dart';
import 'package:firebase_core/firebase_core.dart';
class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  bool isLoading = false;
  TextEditingController usernameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  final formKey=GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  signMeUp(){
    if(formKey.currentState.validate()){
      Map<String,String> userInfoMap ={
        "name" : usernameTextEditingController.text,
        "email": emailTextEditingController.text
      };

      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(usernameTextEditingController.text);
      HelperFunctions.saveUserLoggedInSharedPreference(true);

      setState(() {
            isLoading=true;
          });
          authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){

              databaseMethods.uploadUserToDatabase(userInfoMap);

            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context)=> ChatRoom()
            ));

            });

    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        alignment: Alignment.center,
          child: CircularProgressIndicator()):
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
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return val.isEmpty||val.length<2 ? 'Please provide a username': null;
                        },
                        controller: usernameTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("username"),
                      ),
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
                        obscureText: true,
                        controller: passwordTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("password"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.0,),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text('Forgot Password',
                      style: simpleTextStyle(),
                    ),
                  ),
                ),
                SizedBox(height: 8.0,),

                GestureDetector(
                  onTap: (){
                    signMeUp();
                  },//TODO
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
                    child: Text('Sign Up',
                      style:
                      TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height:17.0),

                Container(

                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text('Sign Up with Google',
                    style:
                    TextStyle(
                      color: Colors.black87,
                      fontSize: 17.0,
                    ),
                  ),
                ),

                SizedBox(height:17.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Already have an account? ",style: mediumTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Sign In ",style: TextStyle(color: Colors.white,
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
