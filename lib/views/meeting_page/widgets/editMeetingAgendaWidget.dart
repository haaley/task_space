import 'package:task_scape/controllers/meeting_page_controller.dart';
import 'package:task_scape/utils/dialogsWidget.dart';
import 'package:flutter/material.dart';

TextEditingController titlecontroller = new TextEditingController();
TextEditingController descriptioncontroller = new TextEditingController();

final GlobalKey<State> _keyLoader = new GlobalKey<State>();

Widget EditMeetingAgenda(BuildContext context, String title, String description,
    int index, int status, String url) {
  titlecontroller.text = title;
  descriptioncontroller.text = description;
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
                        color:Color.fromRGBO(0, 99, 170, 1),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                            child: Form(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: new Icon(Icons.title),
                                    title: TextField(
                                      controller: titlecontroller,
                                      decoration: InputDecoration(
                                        hintText: "Título da Pauta",
                                      ),
                                      textCapitalization:
                                      TextCapitalization.sentences,
                                      maxLength: 100,
                                      maxLengthEnforced: true,
                                    ),
                                  ),
                                  ListTile(
                                    leading: new Icon(Icons.dehaze),
                                    title: TextField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      maxLength: 4000,
                                      maxLengthEnforced: true,
                                      controller: descriptioncontroller,
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
                          onPressed: () async {
                            Map<String, dynamic> newPauta = Map();
                            newPauta["title"] = titlecontroller.text;
                            newPauta["description"] = descriptioncontroller.text;
                            newPauta["status"] = status;

                            Dialogs.showLoadingDialog(
                                context, _keyLoader, "Salvando...");

                            List answ =
                            await MeetingPageController.instance.editAgendaMeeting(newPauta,url);
                            Navigator.of(_keyLoader.currentContext,
                                rootNavigator: true)
                                .pop();

                            if (answ[0] == '200') {
                              MeetingPageController.instance.updateMeetingAgenda(context, titlecontroller.text,
                                  descriptioncontroller.text,status, index);
                              MeetingPageController.instance.statusMeetingAgenda.notifyListeners();

                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');

                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    Future.delayed(Duration(seconds: 3), () {
                                      Navigator.of(context).pop(true);
                                    });
                                    return AlertDialog(
                                      backgroundColor: Colors.black54,
                                      title: Text(
                                        'Erro',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      content: Text(
                                          "Erro de conexão. Tente novamente.",
                                          style: TextStyle(color: Colors.white)),
                                    );
                                  });
                            }
                          },
                          child: Text(
                            "Salvar",
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