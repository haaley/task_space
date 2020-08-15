import 'package:task_scape/model/meetingAgendaProvider.dart';
import 'package:flutter/material.dart';

Widget ListMeetingAgenda(BuildContext context, MeetingAgendaProvider meetingAgenda) {
  return new Container(
      height: 75.0 + 75.0*meetingAgenda.meetingAgendaList.length,
      child: new ListView.builder(
          itemCount: meetingAgenda.meetingAgendaList.length,
          padding: new EdgeInsets.only(top: 5.0),
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(DateTime
                  .now()
                  .millisecondsSinceEpoch
                  .toString()),
              background: Container(
                color: Colors.red,
                child: Align(
                  alignment: Alignment(-0.9, 0.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              direction: DismissDirection.startToEnd,
              child: Container(
                margin:
                const EdgeInsets.only(
                    left: 1.0, right: 1.0, bottom: 1.0, top: 0.0),
                child: new Material(
                  borderRadius: new BorderRadius.circular(6.0),
                  elevation: 2.0,
                  child: ListTile(
                    title: Text(meetingAgenda.meetingAgendaList[index].title),
                  ),
                ),
              ),
              onDismissed: (direction) {

                  meetingAgenda.removeMeetingAgenda(index);

              },
            );
          }
      )
  );
}