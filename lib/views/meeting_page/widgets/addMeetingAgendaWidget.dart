import 'package:task_scape/controllers/meeting_page_controller.dart';
import 'package:task_scape/utils/dialogsWidget.dart';
import 'package:flutter/material.dart';

final GlobalKey<State> _keyLoader = new GlobalKey<State>();

Widget AddMeetingAgenda (BuildContext context, int id) {
  MeetingPageController.instance.titlecontroller.text = "";
  MeetingPageController.instance.descriptioncontroller.text = "";

  showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel:
      MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          transform: Matrix4.translationValues(
            0.0,
            MediaQuery.of(context).viewInsets.bottom * -1.0,
            0.0,
          ),
          child: Center(
              child: Material(
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: MediaQuery.of(context).size.height - 450,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 30,
                        height: MediaQuery.of(context).size.height * 0.02,
                        color: Color.fromRGBO(0, 99, 170, 1),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                            child: Form(
                              key: MeetingPageController.instance.formkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: new Icon(Icons.title),
                                    title: TextFormField(
                                      controller: MeetingPageController.instance.titlecontroller,
                                      decoration: InputDecoration(
                                        hintText: "Título da Pauta",
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty || value.length < 1) {
                                          return 'Coloque um Título.';
                                        }
                                      },
                                      textCapitalization:
                                      TextCapitalization.sentences,
                                      maxLength: 100,
                                      maxLengthEnforced: true,
                                    ),
                                  ),
                                  ListTile(
                                    leading: new Icon(Icons.dehaze),
                                    title: TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      maxLength: 4000,
                                      maxLengthEnforced: true,
                                      controller: MeetingPageController.instance.descriptioncontroller,
                                      decoration: InputDecoration(
                                        hintText: "Descrição",
                                      ),
                                      textCapitalization:
                                      TextCapitalization.sentences,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: RaisedButton(
                          onPressed: ()  async{
                            if (MeetingPageController.instance.formkey.currentState.validate()) {
                              Map<String, dynamic> newPauta = Map();
                              newPauta["title"] = MeetingPageController.instance.titlecontroller.text;
                              newPauta["description"] =
                                  MeetingPageController.instance.descriptioncontroller.text;
                              newPauta["status"] = 1;
                              Dialogs.showLoadingDialog(context, _keyLoader, "Salvando...");
                              await MeetingPageController.instance.addMeetingAgenda(context, id, newPauta);
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          },
                          child: Text(
                            "Adicionar",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 30,
                        height: MediaQuery.of(context).size.height * 0.02,
                        color: Color.fromRGBO(0, 99, 170, 1),
                      ),
                    ],
                  ),
                ),
              )),
        );
      });
}