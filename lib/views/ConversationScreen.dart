import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/helper/constants.dart';
import 'package:flutter_firebase_app/services/database.dart';
import 'package:flutter_firebase_app/widgets/widget.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();

}

class _ConversationScreenState extends State<ConversationScreen> {
 DatabaseMethods databaseMethods = new DatabaseMethods();
TextEditingController messageController = new TextEditingController();
Stream chatMessageStream;

Widget chatMessageList(){
      return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index){
                return MessageTile(
                  message: snapshot.data.documents[index].data()["message"],
                  isSentByMe: snapshot.data.documents[index].data()["sentBy"] == Constants.myName
                );
              }): Container();
        } ,

      );
  }
  sendMessage(){

    if(messageController.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sentBy": Constants.myName,
        "time":  DateTime.now().millisecondsSinceEpoch
       };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text=" ";
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val){
      setState(() {
        chatMessageStream = val;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0xF0000000),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    children: [
                      Expanded(child: TextField(
                          controller: messageController,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText:" Message...",
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                            border: InputBorder.none,
                          )
                      )
                      ),
                      GestureDetector(
                        onTap: (){
                          sendMessage();
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
                            child: Image.asset("assets/images/send.png")),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  MessageTile({this.message, this.isSentByMe});
  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.only(top: 15.0, left: isSentByMe? 0:24, right: isSentByMe? 24:0),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSentByMe?
            [
              const Color(0xff007EF4),
              const Color(0xff2A75BC)
            ]
                :
                [
                  const Color(0x1AFFFFFF),
                  const Color(0x1AFFFFFF)
                ]
          ),
          borderRadius: isSentByMe? 
              BorderRadius.only(
                topLeft: Radius.circular(23.0),
                topRight: Radius.circular(23.0),
                bottomLeft: Radius.circular(23.0)
              ):
              BorderRadius.only(topLeft: Radius.circular(23.0),
                  topRight: Radius.circular(23.0),
                  bottomLeft: Radius.circular(23.0))
        ),
        child: Text(message, style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        )),
      ),
    );
  }
}
