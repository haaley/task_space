import 'package:flutter/material.dart';

Widget showMeetingAgendaAlert(BuildContext context, List meetingAgenda, int index){
  showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel:
      MaterialLocalizations.of(context)
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
                width:
                MediaQuery.of(context).size.width -
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
                        meetingAgenda[index].title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22.0,
                            fontWeight:
                            FontWeight.bold),
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
                              mainAxisSize:
                              MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    meetingAgenda[index].description ==
                                        null
                                        ? ""
                                        : meetingAgenda[index].description,
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
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ));
      });
}