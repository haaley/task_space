import 'package:task_scape/controllers/new_meeting_page_controller.dart';
import 'package:task_scape/utils/dialogsWidget.dart';
import 'package:task_scape/views/home_page/home_page.dart';
import 'package:task_scape/views/new_meeting_page/widgets/addGuestWidgets/emptyAlertWidget.dart';
import 'package:task_scape/views/new_meeting_page/widgets/alertDialogWidget.dart';
import 'package:task_scape/views/new_meeting_page/widgets/createMeetingWidget.dart';
import 'package:task_scape/views/new_meeting_page/widgets/sendEmailWidget.dart';
import 'package:flutter/material.dart';

final GlobalKey<State> _keyLoader = new GlobalKey<State>();

class NewMeetingPage extends StatefulWidget {
  @override
  _NewMeetingPageState createState() => _NewMeetingPageState();
}

class _NewMeetingPageState extends State<NewMeetingPage> {

  @override
  void initState() {
    NewMeetingPageController.instance.initValues();
    NewMeetingPageController.instance.resetConvidados(context);
    NewMeetingPageController.instance.resetPauta(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Nova Reunião"),
            backgroundColor: Color.fromRGBO(0, 99, 170, 1),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                alertDialog(context, "Deseja cancelar a criação da Reunião?",
                    backAction);
              },
            ),
          ),
          body: CreateMeetingStepper(),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: NewMeetingPageController
                                .instance.currentState.value ==
                            0
                        ? null
                        : FlatButton(
                            onPressed: () {
                              setState(() {
                                if (NewMeetingPageController
                                        .instance.currentState.value ==
                                    1) {
                                  print("1 form");
                                }
                                if (NewMeetingPageController
                                            .instance.currentState.value -
                                        1 >=
                                    0) {
                                  NewMeetingPageController
                                      .instance.currentState.value -= 1;
                                  NewMeetingPageController.instance.currentState
                                      .notifyListeners();
                                }
                              });
                            },
                            child: Icon(Icons.chevron_left),
                          ),
                  ),
                ),
                Divider(),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: RaisedButton(
                          onPressed: () async {
                              switch (NewMeetingPageController
                                  .instance.currentState.value) {
                                case 0:
                                  setState(() {
                                    NewMeetingPageController.instance.validateInfo();

                                  });
                                  break;
                                case 1:
                                if(NewMeetingPageController.instance.getListGuest(context).isNotEmpty){
                                  setState(() {
                                    NewMeetingPageController.instance.saveGuest(context);
                                    NewMeetingPageController
                                        .instance.currentState.value += 1;
                                    NewMeetingPageController.instance.currentState
                                        .notifyListeners();
                                  });

                                  }
                                else{
                                  setState(() {
                                    emptyAlert(context, "convidados");
                                  });
                                }
                                  break;
                                case 2:
                                  if(NewMeetingPageController.instance.getListMeetingAgenda(context).isNotEmpty){
                                    NewMeetingPageController.instance.saveMeetingAgenda(context);
                                    Dialogs.showLoadingDialog(context, _keyLoader, "Salvando...");
                                    await NewMeetingPageController.instance.newMeetingPost(context);
                                    if(NewMeetingPageController.instance.statusPost == '201'){
                                      setState(() {
                                        NewMeetingPageController
                                            .instance.currentState.value = 0;
                                        NewMeetingPageController.instance.currentState
                                            .notifyListeners();

                                        Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()),
                                                (Route<dynamic> route) => false);
                                      });

                                      SendEmailAlertDialog(context,"Deseja enviar email convite para os participantes?");

                                    }

                                  }else{
                                    setState(() {
                                      emptyAlert(context, "pautas");
                                    });
                                  }
                              }
                          },
                          color: NewMeetingPageController
                                      .instance.currentState.value !=
                                  2
                              ? Colors.blueAccent
                              : Colors.green,
                          child: Icon(
                            NewMeetingPageController
                                        .instance.currentState.value !=
                                    2
                                ? Icons.chevron_right
                                : Icons.check,
                            color: Colors.white,
                          ),
                        )))
              ],
            ),
          ),
        ));
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
