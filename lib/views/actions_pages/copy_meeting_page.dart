import 'package:task_scape/controllers/meeting_page_controller.dart';
import 'package:task_scape/controllers/new_meeting_page_controller.dart';
import 'package:task_scape/services/newMeetingPageService.dart';
import 'package:task_scape/views/home_page/home_page.dart';
import 'package:task_scape/views/new_meeting_page/widgets/DatePickerWidget.dart';
import 'package:task_scape/views/new_meeting_page/widgets/sendEmailWidget.dart';
import 'package:flutter/material.dart';

import '../new_meeting_page/widgets/alertDialogWidget.dart';

GlobalKey<FormState> formkey = GlobalKey<FormState>();

class CopyMeeting extends StatefulWidget {
  final id;
  final self;

  const CopyMeeting({Key key, this.id, this.self}) : super(key: key);

  @override
  _CopyMeetingState createState() => _CopyMeetingState();
}

class _CopyMeetingState extends State<CopyMeeting> {
  @override
  void initState() {
    super.initState();
    NewMeetingPageController.instance.getDataMeeting(widget.self);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Copiar Reunião"),
            centerTitle: true,
            leading: new IconButton(
              icon: new Icon(Icons.close),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Atenção',
                          textAlign: TextAlign.center,
                        ),
                        content: Text('Deseja cancelar a cópia da Reunião?'),
                        actions: <Widget>[
                          FlatButton(
                              child: Text('Sim'),
                              onPressed: () {
                                Navigator.of(context).pop(false);

                                Navigator.of(context).pop(false);
                              }),
                          FlatButton(
                            child: Text('Não'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
          body: FutureBuilder(
            future: NewMeetingPageController.instance.getDataMeeting(widget.self),
            builder: (BuildContext context, snapshot){
              if(snapshot.connectionState== ConnectionState.done){
                return Form(
                  key: formkey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        new ListTile(
                          leading: new Icon(Icons.title),
                          title: new TextFormField(
                            validator: (value) {
                              if (value.isEmpty || value.length < 1) {
                                return 'Coloque um título.';
                              }
                            },
                            textCapitalization: TextCapitalization.sentences,
                            maxLength: 100,
                            maxLengthEnforced: true,
                            controller: NewMeetingPageController.instance.titleController,
                            onSaved: (value) {
                              NewMeetingPageController.instance.data['title'] = value;
                            },
                            decoration: new InputDecoration(
                              hintText: "Título",
                            ),
                          ),
                        ),
                        new ListTile(
                          leading: new Icon(Icons.location_on),
                          title: new TextFormField(
                            validator: (value) {
                              if (value.isEmpty || value.length < 1) {
                                return 'Coloque um local.';
                              }
                            },
                            maxLength: 50,
                            maxLengthEnforced: true,
                            textCapitalization: TextCapitalization.sentences,
                            controller: NewMeetingPageController.instance.localController,
                            onSaved: (value) {
                              NewMeetingPageController.instance.data['localMeeting'] = value;
                            },
                            decoration: new InputDecoration(
                              hintText: "Local",
                            ),
                          ),
                        ),
                        new ListTile(
                          leading: new Icon(Icons.date_range),
                          title: DatePick(NewMeetingPageController.instance.identifyStartDate),
                        ),
                        new ListTile(
                          leading: new Icon(Icons.calendar_today),
                          title: DatePick(NewMeetingPageController.instance.identifyEndDate),
                        ),
                        new ListTile(
                          leading: new Icon(Icons.dehaze),
                          title: new TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            maxLength: 500,
                            maxLengthEnforced: true,
                            validator: (value) {
                              if (value.isEmpty || value.length < 1) {
                                return 'Insira uma descrição.';
                              }
                            },
                            textCapitalization: TextCapitalization.sentences,
                            onSaved: (value) {
                              NewMeetingPageController.instance.data['description'] = value;
                            },
                            controller: NewMeetingPageController.instance.descriptionController,
                            decoration: new InputDecoration(
                              hintText: "Descrição da reunião.",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              else{
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
          bottomNavigationBar: BottomAppBar(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: RaisedButton(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: Text(
                                "Salvar",
                                style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        color: Colors.green,
                        onPressed: () async {
                          if (formkey.currentState.validate()) {
                            formkey.currentState.save();
                            NewMeetingPageController.instance.data['guestList'] = NewMeetingPageController.instance.guestList;
                            NewMeetingPageController.instance.data['agendaList'] = NewMeetingPageController.instance.meetingagendaList;
                            await NewMeetingPageController.instance.CopyMeetingPost(context);
                            if(NewMeetingPageController.instance.statusPost  == '201'){
                              setState(() {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage(tab: 0)),
                                        (Route<dynamic> route) => false);
                              });

                              SendEmailAlertDialog(context, "Deseja enviar email convite para os participantes?");
                            }

                          } else {
                            print("Erro");
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }
  Future<bool> _onBackPressed() {
    return alertDialog(
        context, "Deseja cancelar a criação da Reunião?", backAction) ??
        false;
  }
}

void backAction(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false);
}
