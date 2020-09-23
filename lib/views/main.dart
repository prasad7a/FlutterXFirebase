import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/helper/HelperFunctions.dart';
import 'package:flutter_firebase_app/helper/authenticate.dart';
import 'package:flutter_firebase_app/views/ChatRoomScreen.dart';
import 'package:flutter_firebase_app/views/signin.dart';
import 'package:flutter_firebase_app/views/signup.dart';
import 'package:firebase_core/firebase_core.dart';
 void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(MyApp());
}


class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

   bool userIsLoggedIn = false;
   @override
  void initState() {
     getLoggedInState();
    super.initState();
  }

  getLoggedInState() async{
     await HelperFunctions.getUserLoggedInSharedPreference().then((val){
        setState(() {
          userIsLoggedIn=val;
        });
     });
  }

   @override
  Widget build(BuildContext context) {

        return MaterialApp(

      title: 'Chat App',
      debugShowCheckedModeBanner: false,
          theme: ThemeData(
            //primaryColor: Color(0xff145C9E),
            scaffoldBackgroundColor: Color(0xff1F1F1F),
            accentColor: Color(0xff007EF4),
            fontFamily: "OverpassRegular",
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
      home: userIsLoggedIn!= null? userIsLoggedIn ? ChatRoom() : Authenticate(): Container(
        child: Center(
          child: Authenticate(),
        ),
      ),
    );
  }
}



