import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/helper/constants.dart';
import 'package:flutter_firebase_app/services/database.dart';
import 'package:flutter_firebase_app/views/ConversationScreen.dart';
import 'package:flutter_firebase_app/widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

DatabaseMethods databaseMethods=new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();
    QuerySnapshot searchSnapshot;

initiateSearch(){
  databaseMethods.getUserByUsername(searchTextEditingController.text).then((val){
       setState(() {
         searchSnapshot=val;
       });
  });
}

//create chatroom, send user to conversation screen, pushReplacement

  Widget searchList(){
    return searchSnapshot != null ?ListView.builder(itemCount: searchSnapshot.docs.length ,
        shrinkWrap : true, itemBuilder: (context,index){

          return searchTile(
              userName: searchSnapshot.docs[index].data()['name'],
              userEmail: searchSnapshot.docs[index].data()['email']
          );
        }): Container();
  }

  createChatRoomAndStartConversation({String userName}){
  print('${Constants.myName} haha');
   if(userName != Constants.myName){
     String chatRoomId = getChatRoomId(userName, Constants.myName);
     List<String> users = [userName, Constants.myName];
     Map<String, dynamic> chatRoomMap = {
       "users": users,
       "chatRoomID":chatRoomId
     };

     DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
     Navigator.push(context, MaterialPageRoute(
         builder: (context)=> ConversationScreen(chatRoomId)
     ));
   }else{
     print('You cannot send a message to yourself!');
   }
  }

  Widget searchTile({String userName, String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: TextStyle(color: Colors.white,
                  fontSize: 19.0, fontWeight: FontWeight.bold)),
              Text(userEmail,style: simpleTextStyle(),),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child:Text('Message', style: mediumTextStyle(),),
            ),
          ),
        ],
      ),
    );

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText:" Enter username...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none,
                      )
                    )
      ),
                  GestureDetector(
                    onTap: (){
                     initiateSearch();
                    },
                    child: Container(
                        padding: EdgeInsets.all(8.0),
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0fFFFFFF),
                            ]
                          ),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Image.asset("assets/images/search.png")),
                  ),
                  ],
                ),
              ),
            ),
            searchList(),
          ],

        ),
      ),

    );
  }
}


//class SearchTile extends StatelessWidget {
//  final String userName;
//  final String userEmail;
//  SearchTile({this.userName,this.userEmail});
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//      child: Row(
//        children: [
//          Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
//              Text(userName, style: TextStyle(color: Colors.white,
//                fontSize: 19.0, fontWeight: FontWeight.bold)),
//              Text(userEmail,style: simpleTextStyle(),),
//            ],
//          ),
//          Spacer(),
//          GestureDetector(
//            onTap: (){
//              createChatRoomAndStartConversation(context: context, )
//            },
//            child: Container(
//              decoration: BoxDecoration(
//                color: Colors.blue,
//                borderRadius: BorderRadius.circular(30.0),
//              ),
//              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//              child:Text('Message', style: mediumTextStyle(),),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}


getChatRoomId(String a, String b){
  if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }else{
    return "$a\_$b";
  }
}
