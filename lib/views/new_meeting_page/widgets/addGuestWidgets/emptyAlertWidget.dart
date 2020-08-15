import 'package:flutter/material.dart';

Widget emptyAlert(BuildContext context, String message) {
  Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      });

  //configura o AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
    title: Icon(Icons.info, size: 56.0, color: Colors.orange,),
    content: Text("Atenção! \nNão é possível criar uma nova reunião sem $message.", style: TextStyle(fontFamily: "WorkSansSemiBold"), textAlign: TextAlign.center,),
    actions: [
      okButton,
    ],
  );

  //exibe o diálogo
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
