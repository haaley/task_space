import 'package:task_scape/controllers/meeting_page_controller.dart';
import 'package:task_scape/model/meetingAgendaProvider.dart';
import 'package:flutter/material.dart';


DeleteAlertDialog(BuildContext context, MeetingAgendaProvider meetingAgenda, int index){
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
      title: Icon(Icons.info, size: 56.0, color: Colors.orange,),
      content: Text(
        'Você deseja remover esta pauta?', style: TextStyle(fontFamily: "WorkSansSemiBold"), textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        FlatButton(
            child: Text("Sim"),
            onPressed: () async{
              Navigator.of(context).pop(true);
              await MeetingPageController.instance.deleteMeetingAgenda(
                  meetingAgenda.meetingAgendaList[index].self);
              meetingAgenda.removeMeetingAgenda(index);

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
}