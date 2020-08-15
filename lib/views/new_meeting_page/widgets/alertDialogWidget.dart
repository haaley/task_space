import 'package:flutter/material.dart';

alertDialog(BuildContext context, String message, action){
  showDialog(context: context, builder: (context){
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
      title: Icon(Icons.info, size: 56.0, color: Colors.orange,),
      content: Text(
        message, style: TextStyle(fontFamily: "WorkSansSemiBold"), textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        FlatButton(
            child: Text("Sim"),
            onPressed: (){
              action(context);
            }
        ),
        FlatButton(
          child: Text("Não"),
          onPressed: (){
            Navigator.of(context).pop(false);
          },
        )
      ],
    );
  });
}