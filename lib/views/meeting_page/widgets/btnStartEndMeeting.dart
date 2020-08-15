import 'package:task_scape/controllers/meeting_page_controller.dart';
import 'package:task_scape/views/home_page/home_page.dart';
import 'package:flutter/material.dart';

class BtnStartEndMeeting extends StatefulWidget {

  final id;
  final status;
  final type;

  const BtnStartEndMeeting({Key key, this.id, this.status, this.type}) : super(key: key);


  @override
  _BtnStartEndMeetingState createState() => _BtnStartEndMeetingState();
}

class _BtnStartEndMeetingState extends State<BtnStartEndMeeting> {
  bool confirmado = false;
  bool finishbtn = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 8.0,
        borderRadius: new BorderRadius.circular(30.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(30.0),
            color: (widget.status == "SCHEDULED" && !confirmado)
                ? Colors.green
                : (!confirmado && widget.status == "FINISHED")
                ? Colors.grey
                : Colors.red,
          ),
          height: 50,
          width: 120,
          child: Row(
            children: <Widget>[
              FlatButton(
                onPressed: widget.status == "FINISHED"
                    ? null
                    : () {
                  if (widget.status == 'SCHEDULED' && !confirmado) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Atenção',
                              textAlign: TextAlign.center,
                            ),
                            content: Text('Deseja iniciar a Reunião?'),
                            actions: <Widget>[
                              FlatButton(
                                  child: Text('Sim'),
                                  onPressed: () {
                                    setState(() {});
                                    Navigator.of(context).pop(false);
                                    MeetingPageController.instance.updateMeeting(MeetingPageController.instance.startURL);
                                    confirmado = true;
                                  }),
                              FlatButton(
                                child: Text('Não'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                            ],
                          );
                        });
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Atenção',
                              textAlign: TextAlign.center,
                            ),
                            content: Text('Deseja encerrar a Reunião?'),
                            actions: <Widget>[

                              FlatButton(
                                  child: Text('Sim'),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                    MeetingPageController.instance.updateMeeting(MeetingPageController.instance.endURL);
                                    finishbtn = true;
                                    Navigator.of(context)
                                        .pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                HomePage(tab:widget.type)),
                                            (Route<dynamic> route) =>
                                        false);

                                  }),
                              FlatButton(
                                child: Text('Não'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                            ],
                          );
                        });
                  }
                },
                child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          confirmado && widget.status == 'SCHEDULED'
                              ? Icons.stop
                              : !confirmado && widget.status == 'STARTED'
                              ? Icons.stop
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        Text(
                            confirmado && widget.status == 'SCHEDULED'
                                ? 'Terminar'
                                : !confirmado && widget.status == 'STARTED'
                                ? "Terminar"
                                : "Iniciar",
                            style: TextStyle(color: Colors.white)),
                      ],
                    )),
              )
            ],
          ),
        ));
  }
}
