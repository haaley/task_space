import 'package:task_scape/model/guestProvider.dart';
import 'package:task_scape/model/meetingAgendaProvider.dart';
import 'package:flutter/material.dart';

Widget StaticMeetingAgendaList(MeetingAgendaProvider meetingAgenda, int id) {
  return new Container(
      height: 75.0 + 75.0 * meetingAgenda.meetingAgendaList.length,
      child: new ListView.builder(
          itemCount: meetingAgenda.meetingAgendaList.length,
          padding: new EdgeInsets.only(top: 5.0),
          itemBuilder: (BuildContext context, int index) {
            return Container(
                margin: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 0.0),
                child: new Material(
                    borderRadius: new BorderRadius.circular(6.0),
                    elevation: 2.0,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: new BorderRadius.circular(10.0),
                          color: Colors.grey[200]),
                      child: ListTile(
                        leading: CircleAvatar(
                            child: Icon(Icons.description),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue),
                        title: Text(
                          meetingAgenda.meetingAgendaList[index].title,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          meetingAgenda.meetingAgendaList[index].description == null
                              ? ""
                              : meetingAgenda.meetingAgendaList[index].description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        onTap: () {
                          showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: MaterialLocalizations.of(context)
                                  .modalBarrierDismissLabel,
                              barrierColor: Colors.black45,
                              transitionDuration:
                              const Duration(milliseconds: 200),
                              pageBuilder: (BuildContext buildContext,
                                  Animation animation,
                                  Animation secondaryAnimation) {
                                return Center(
                                    child: Material(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width -
                                            30,
                                        height:
                                        MediaQuery.of(context).size.height -
                                            100,
                                        color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            ListTile(
                                              title: Text(
                                                meetingAgenda.meetingAgendaList[index].title,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 22.0,
                                                    fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            new Divider(
                                              color: Colors.blueGrey,
                                              height: 10.0,
                                            ),
                                            Expanded(
                                                child: SingleChildScrollView(
                                                  child: Form(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        ListTile(
                                                          title: Text(
                                                            meetingAgenda.meetingAgendaList[index]
                                                                .description ==
                                                                null
                                                                ? ""
                                                                : meetingAgenda.meetingAgendaList[index]
                                                                .description,
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 16.0),
                                                            textAlign:
                                                            TextAlign.justify,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                            Padding(
                                              padding:
                                              EdgeInsets.only(bottom: 10.0),
                                              child: RaisedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Fechar",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                color: Color.fromRGBO(0, 99, 170, 1),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                                  30,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.03,
                                              color: Color.fromRGBO(0, 99, 170, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                              });
                        },
                      ),
                    )));
          }));
}