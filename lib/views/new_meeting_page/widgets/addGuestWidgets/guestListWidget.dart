import 'package:task_scape/controllers/new_meeting_page_controller.dart';
import 'package:task_scape/model/guestProvider.dart';
import 'package:task_scape/views/new_meeting_page/widgets/addGuestWidgets/guestTileWidget.dart';
import 'package:flutter/material.dart';

Widget GuestList(GuestModel guestList, BuildContext context) {

  return SingleChildScrollView(
    child: new Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: new ListView.builder(
            itemCount: guestList.guestList.length,
            padding: new EdgeInsets.only(top: 5.0),
            itemBuilder: (context, index) {
              NewMeetingPageController.instance.status.value.clear();
              guestList.guestList.forEach((element) {
                NewMeetingPageController.instance.status.value.add(element.status);
              });
              return Dismissible(
                direction: DismissDirection.startToEnd,
                key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                background: Container(
                  color: Colors.redAccent,
                  child: Align(
                    alignment: Alignment(-0.9, 0.0),
                    child: Icon(Icons.delete_sweep, color: Colors.white),
                  ),
                ),
                confirmDismiss: (DismissDirection direction) async {
                  final bool res = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Atenção"),
                        content: const Text("Deseja remover este convidado?"),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                guestList.removeGuest(index);
                                Navigator.of(context).pop(true);
                              },
                              child: const Text("Sim")),
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Cancelar"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10.0, top: 0.0),
                  child: new Material(
                    borderRadius: new BorderRadius.circular(6.0),
                    elevation: 2.0,
                    child: GuestListTile(guestList, index),
                  ),
                ),
              );
            })),
  );
}