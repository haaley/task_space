import 'package:task_scape/common/UserData.dart';
import 'package:task_scape/controllers/meeting_page_controller.dart';
import 'package:task_scape/utils/dialogsWidget.dart';
import 'package:task_scape/views/actions_pages/edit_guests_page.dart';
import 'package:task_scape/views/actions_pages/edit_meeting_page.dart';
import 'package:task_scape/views/actions_pages/copy_meeting_page.dart';
import 'package:task_scape/views/meeting_page/widgets/addMeetingAgendaWidget.dart';
import 'package:task_scape/views/meeting_page/widgets/btnStartEndMeeting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

final GlobalKey<State> _keyLoader = new GlobalKey<State>();

Widget FloatingActionButtons(BuildContext context, int type, Map<String,dynamic> meeting) {
  if (type > 0) {
    return Offstage(
      child: Stack(
        children: <Widget>[
          Offstage(
            child: Padding(
                padding: EdgeInsets.only(left: 31, bottom: 10),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: BtnStartEndMeeting(
                      id: meeting['idMeeting'],
                      status: meeting['status'],
                      type: 0),
                )),
            offstage: type != 1,
          ),
          SpeedDial(
              // both default to 16
              marginRight: 18,
              marginBottom: 20,
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 22.0),
              // this is ignored if animatedIcon is non null
              // child: Icon(Icons.add),
              visible: true,
              // If true user is forced to close dial manually
              // by tapping main button and overlay is not rendered.
              closeManually: false,
              curve: Curves.bounceIn,
              overlayColor: Colors.black,
              overlayOpacity: 0.5,
              onOpen: () {},
              onClose: () {},
              tooltip: 'Opções',
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 8.0,
              shape: CircleBorder(),
              children: _getSpeedDials(context, type, meeting)),
        ],
      ),
      offstage: meeting['idAuthor'] != UserData().id && !MeetingPageController.instance.isAuthor,
    );
  } else {
    return Stack(children: <Widget>[
      SpeedDial(
        // both default to 16
          marginRight: 18,
          marginBottom: 20,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          // this is ignored if animatedIcon is non null
          // child: Icon(Icons.add),
          visible: true,
          // If true user is forced to close dial manually
          // by tapping main button and overlay is not rendered.
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () {},
          onClose: () {},
          tooltip: 'Opções',
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 8.0,
          shape: CircleBorder(),
          children: _getSpeedDials(context, type, meeting))
    ]);
  }
}


_getSpeedDials(BuildContext context, int type, Map<String, dynamic> meeting) {
  if (type == 0) {
    if (meeting['status'] == 'FINISHED') {
      if(meeting['idAuthor'] == UserData().id  || MeetingPageController.instance.isAuthor){
        return [
         pdfSpeedDial(context, meeting),
          copySpeedDial(context, meeting)
        ];
      }
      else{
        return [
         pdfSpeedDial(context, meeting)
        ];
      }

    } else {
      if (meeting['idAuthor'] == UserData().id  || MeetingPageController.instance.isAuthor) {
        return [
          editSpeedDial(context, meeting),
          copySpeedDial(context, meeting),
          pdfSpeedDial(context, meeting)

        ];
      } else {
        return [
          pdfSpeedDial(context, meeting)
        ];
      }
    }
  } else{
    if(meeting['idAuthor'] == UserData().id  || MeetingPageController.instance.isAuthor) {
      return [
        editGuestSpeedDial(context, meeting, type),
        addMeetingAgendaSpeedDial(context, meeting['idMeeting']),
        editSpeedDial(context, meeting),
        pdfSpeedDial(context, meeting)
      ];
    }
    else{
      return[
        pdfSpeedDial(context, meeting)
      ];
    }
  }
}

SpeedDialChild pdfSpeedDial(BuildContext context, Map<String, dynamic> meeting){
  return
    SpeedDialChild(
        child: Icon(Icons.picture_as_pdf),
        backgroundColor: Colors.blue,
        labelWidget: Text(
          'Gerar Pdf',
          style: TextStyle(color: Colors.white),
        ),
        labelStyle: TextStyle(fontSize: 12.0),
        onTap: () async {
          Dialogs.showLoadingDialog(
              context, _keyLoader, "Baixando Ata...");
          await MeetingPageController.instance.exportPdf(meeting['idMeeting']);
          Navigator.of(_keyLoader.currentContext, rootNavigator: true)
              .pop();
        });
}

SpeedDialChild editSpeedDial(BuildContext context, Map<String, dynamic> meeting){
  return SpeedDialChild(
      child: Icon(Icons.edit),
      backgroundColor: Colors.blue,
      labelWidget: Text(
        'Editar Reunião',
        style: TextStyle(color: Colors.white),
      ),
      labelStyle: TextStyle(fontSize: 12.0),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    EditMeeting(
                      id: meeting['idMeeting'],
                      self: meeting['self'],
                    )));
      });
}

SpeedDialChild editGuestSpeedDial(BuildContext context, Map<String, dynamic> meeting, int type){
  return SpeedDialChild(
      child: Icon(Icons.group),
      backgroundColor: Colors.blue,
      labelWidget: Text(
        'Editar Convidados',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    EditGuests(
                        self: meeting['self'],
                        id: meeting['idMeeting'],
                        tab: type
                    )));
      });
}

SpeedDialChild addMeetingAgendaSpeedDial(BuildContext context, int idMeeting){
  return SpeedDialChild(
      child: Icon(Icons.note_add),
      backgroundColor: Colors.blue,
      labelWidget: Text(
        'Adicionar Pautas',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        AddMeetingAgenda(context, idMeeting);
      });
}

SpeedDialChild copySpeedDial(BuildContext context, Map<String, dynamic> meeting){
  return SpeedDialChild(
      child: Icon(Icons.content_copy),
      backgroundColor: Colors.blue,
      labelWidget: Text(
        'Copiar Reunião',
        style: TextStyle(color: Colors.white),
      ),
      labelStyle: TextStyle(fontSize: 12.0),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CopyMeeting(
                  id: meeting['idMeeting'],
                  self: meeting['self'],
                )));
      });
}
