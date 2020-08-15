import 'package:task_scape/controllers/new_meeting_page_controller.dart';
import 'package:task_scape/utils/dialogsWidget.dart';
import 'package:flutter/material.dart';

final GlobalKey<State> _keyLoader = new GlobalKey<State>();

Widget NewOutsideGuest(BuildContext context) {
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return AnimatedContainer(
          padding: MediaQuery.of(context).viewInsets,
          duration: Duration(milliseconds: 200),
          child: Center(
              child: Material(
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: MediaQuery.of(context).size.height * 0.4,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 30,
                        height: MediaQuery.of(context).size.height * 0.02,
                        color: Colors.blue,
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: new Icon(Icons.title),
                                    title: TextFormField(
                                      controller: namecontroller,
                                      decoration: InputDecoration(
                                        hintText: "Nome:",
                                      ),
                                      textCapitalization: TextCapitalization.sentences,
                                      maxLength: 100,
                                      maxLengthEnforced: true,
                                      validator: (value) {
                                        if (value.isEmpty || value.length < 2) {
                                          return 'Coloque um Nome válido.';
                                        }
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    leading: new Icon(Icons.dehaze),
                                    title: TextFormField(
                                      maxLines: 1,
                                      maxLength: 100,
                                      maxLengthEnforced: true,
                                      controller: emailcontroller,
                                      decoration: InputDecoration(
                                        hintText: "Email",
                                      ),
                                      textCapitalization: TextCapitalization.sentences,
                                      validator: (value) {
                                        if (value.isEmpty ||
                                            value.length < 2 ||
                                            !value.contains("@")) {
                                          return 'Coloque um Email válido.';
                                        }
                                      },
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
                            if (_formkey.currentState.validate()) {
                              Map<String, dynamic> guest = Map();
                              guest["name"] = namecontroller.text;
                              guest["email"] = emailcontroller.text;
                              guest["contact"] = 0;
                              Dialogs.showLoadingDialog(
                                  context, _keyLoader, "Adicionando...");
                              Map newguest = await NewMeetingPageController.instance.outsideGuest(guest);
                              Navigator.of(context).pop();
                              if (newguest.containsKey('erro')) {
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
                              } else {
                                NewMeetingPageController.instance.addOutGuest(context, newguest);
                                Navigator.of(context).pop();
                              }
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
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              )),
        );
      });
}

