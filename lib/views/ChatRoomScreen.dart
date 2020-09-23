import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/helper/HelperFunctions.dart';
import 'package:flutter_firebase_app/helper/authenticate.dart';
import 'package:flutter_firebase_app/helper/constants.dart';
import 'package:flutter_firebase_app/services/auth.dart';
import 'package:flutter_firebase_app/services/database.dart';
import 'package:flutter_firebase_app/views/ConversationScreen.dart';
import 'package:flutter_firebase_app/views/SearchScreen.dart';
import 'package:flutter_firebase_app/views/signin.dart';
import 'package:flutter_firebase_app/widgets/widget.dart';
class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods;
  DatabaseMethods databaseMethods = new DatabaseMethods();
    Stream chatRoomsStream;

    Widget chatRoomList(){
      return StreamBuilder(
        stream: chatRoomsStream,
          builder: (context, snapshot){
          return snapshot.hasData? ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder:(context, index){
            return ChatRoomTile(
                username: snapshot.data.documents[index].data()["chatRoomID"].toString().replaceAll(Constants.myName,""),
                chatRoom: snapshot.data.documents[index].data()["chatRoomID"]
            ) ;
          }) : Container();
          },
          );
    }
  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((val){
      setState(() {
        chatRoomsStream=val;
      });

    });
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterXFirebase'),
        actions: [
          GestureDetector(
            onTap: (){
              AuthMethods().signOut();
              HelperFunctions.saveUserLoggedInSharedPreference(false);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Authenticate()
              ));
            },
            child: Container(

                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.exit_to_app)),
          ),

        ],
      ),
          body: chatRoomList(),
          floatingActionButton:FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context)=> SearchScreen()
              ));
            },
          ) ,

    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatRoom;
  ChatRoomTile({this.username, this.chatRoom});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=> ConversationScreen(chatRoom)
          ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Text("${username.substring(0,1).toUpperCase()}",
                style: mediumTextStyle(),),
            ),
            SizedBox(width: 8.0),
            Text(username, style: mediumTextStyle(),),
          ],
        ),
      ),
    );
  }
}
