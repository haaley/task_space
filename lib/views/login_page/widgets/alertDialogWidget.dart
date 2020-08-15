import 'package:flutter/material.dart';

 alertDialog(BuildContext context, String message){
  showDialog(context: context, builder: (context){
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
      title: Icon(Icons.info, size: 56.0, color: Colors.orange,),
      content: Text(
        message, style: TextStyle(fontFamily: "WorkSansSemiBold"), textAlign: TextAlign.justify,
      ),
      actions: <Widget>[
        FlatButton(
            child: Text('Ok'),
            onPressed: (){
              Navigator.of(context).pop(false);
            }
        ),
      ],
    );
  });
}