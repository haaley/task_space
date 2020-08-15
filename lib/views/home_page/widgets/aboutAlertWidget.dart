import 'package:flutter/material.dart';

AboutAlertWidget(BuildContext context,
    String appname,
    String apiversion,
    String version) {

  Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      }
  );

  AlertDialog alert = AlertDialog(
    title: Text("Sobre",textAlign: TextAlign.center,),
    titlePadding: EdgeInsets.all(10.0),
    content: Text("Nome do Aplicativo: ${appname}\n\n" +
        "Aplicativo para gerenciamento de reuniões.\n\n" + ""
        "Secretaria de Estado da Fazenda do Maranhão \n\n "+
        "Versão: ${version}\n\n" + "API Versão: ${apiversion}",
      textAlign: TextAlign.center
    ),
    contentPadding: EdgeInsets.all(10.0),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}