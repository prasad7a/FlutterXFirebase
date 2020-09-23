import 'package:flutter/material.dart';

    Widget appBarMain(BuildContext context){
      return AppBar(
        title: Text('Flutter x Firebase',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,

        ),),
      );
    }

    InputDecoration textFieldInputDecoration(String hintText){
      return InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white54,

          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          )
      );
    }

    TextStyle simpleTextStyle(){
      return TextStyle(
        color: Colors.white,
        fontSize: 15.0,
      );
    }

TextStyle mediumTextStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 17.0,
  );
}