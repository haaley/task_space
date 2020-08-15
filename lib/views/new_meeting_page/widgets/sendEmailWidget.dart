import 'package:task_scape/controllers/new_meeting_page_controller.dart';
import 'package:task_scape/utils/dialogsWidget.dart';
import 'package:flutter/material.dart';

final GlobalKey<State> _keyLoader = new GlobalKey<State>();

Widget SendEmailAlertDialog(BuildContext context, String message){
  showDialog(context: context, builder: (context){
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
      title: Icon(Icons.info, size: 56.0, color: Colors.orange,),
      content: Text(
        message, style: TextStyle(fontFamily: "WorkSansSemiBold"), textAlign: TextAlign.justify,
      ),
      actions: <Widget>[
        FlatButton(
            child: Text('Sim'),
            onPressed: ()async{
              Dialogs.showLoadingDialog(context, _keyLoader, "Enviando...");
              int resp = await NewMeetingPageController.instance.sendEmail();
              Navigator.of(_keyLoader.currentContext,
                  rootNavigator: true)
                  .pop();

              if(resp.toString() == "200"){
                Navigator.of(context).pop(false);
              }
              else{
                Navigator.of(context).pop(false);
                showDialog(
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(seconds: 3), () {
                        Navigator.of(context).pop(true);
                      });
                      return AlertDialog(
                        backgroundColor: Colors.black54,
                        title: Text('Erro', style: TextStyle(color: Colors.white),),
                        content: Text("Erro de conexão.", style: TextStyle(color: Colors.white)),
                      );
                    });
              }

            }
        ),
        FlatButton(
            child: Text('Não'),
            onPressed: (){
              Navigator.of(context).pop(false);
            }
        ),
      ],
    );
  });
}