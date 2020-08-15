import 'package:task_scape/controllers/new_meeting_page_controller.dart';
import 'package:task_scape/model/meetingAgenda.dart';
import 'package:task_scape/model/meetingAgendaProvider.dart';
import 'package:task_scape/views/new_meeting_page/widgets/listMeetingAgendaWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewMeetingAgenda extends StatefulWidget {
  @override
  _NewMeetingAgendaState createState() => _NewMeetingAgendaState();
}

class _NewMeetingAgendaState extends State<NewMeetingAgenda> {
  List _listMeetingAgenda = [];
  MeetingAgendaProvider newMeetingAgenda = new MeetingAgendaProvider();

  @override
  void initState() {
    super.initState();
    setState(() {
      newMeetingAgenda.meetingAgendaList.forEach((p) {
        Map<String, dynamic> newMeeting = Map();
        newMeeting["title"] = p.title;
        newMeeting["description"] = "";
        newMeeting["status"] = 0;
        print(p.title);

        _listMeetingAgenda.add(newMeeting);


      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.fromLTRB(8.0, 10.0, 7.0, 5.0),
            child: new Material(
              borderRadius: new BorderRadius.circular(6.0),
              elevation: 2.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: new Icon(Icons.title),
                    title: TextField(
                      controller: NewMeetingPageController.instance.titleMeetingAgendaController,
                      decoration: InputDecoration(
                        hintText: "Título da Pauta",
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 100,
                      maxLengthEnforced: true,
                    ),
                  ),
                ],
              ),
            )
        ),
        Center(
          child: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            onPressed: _addMeetingAgenda,
            child: Icon(Icons.add),
          ),
        ),
        Center(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Pautas Adicionadas",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
            )
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Consumer<MeetingAgendaProvider>(
              builder: (context, meetingAgenda, child) => ListMeetingAgenda(context, meetingAgenda)),
        )
      ],
    );
  }

  void _addMeetingAgenda() {
    setState(() {
      if(NewMeetingPageController.instance.titleMeetingAgendaController.text.isNotEmpty){

        Map<String, dynamic> newAgenda = Map();
        newAgenda["title"] = NewMeetingPageController.instance.titleMeetingAgendaController.text;
        newAgenda["description"] ="";

        NewMeetingPageController.instance.titleMeetingAgendaController.text = "";
        MeetingAgenda p = MeetingAgenda(title: newAgenda['title'], description: newAgenda['description']);

        newMeetingAgenda.addMeetingAgenda(p);
        _listMeetingAgenda.add(newAgenda);
        NewMeetingPageController.instance.addMeetingAgenda(context, p);
      }

    });
  }

}
