import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseMethods{
    getUserByUsername(String username) async{

      return await FirebaseFirestore.instance.collection("users").where("name", isEqualTo: username).get();
   }

    getUserByUserEmail(String userEmail) async{

      return await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: userEmail).get();
    }

   uploadUserToDatabase(userMap){
        FirebaseFirestore.instance.collection("users").add(userMap); //To add to DB without documentation
        //FirebaseFirestore.instance.collection("users").doc().set(data); //In case documentation is also needed
   }
   
   createChatRoom(String chatRoomId, chatRoomMap  ){
      FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap)
          .catchError((e){print(e.toString());
          });
   }

   addConversationMessages(String chatRoomId, messageMap){
      FirebaseFirestore.instance.collection("ChatRoom")
          .doc(chatRoomId)
          .collection("chats")
          .add(messageMap).catchError((e){
            e.toString();
      });
   }
    getConversationMessages(String chatRoomId) async{
      return await FirebaseFirestore.instance.collection("ChatRoom")
          .doc(chatRoomId)
          .collection("chats").orderBy("time", descending: false)
          .snapshots();
    }

    getChatRooms(String userName) async{
      return await FirebaseFirestore.instance
          .collection("ChatRoom")
          .where("users", arrayContains: userName )
          .snapshots();
    }
}