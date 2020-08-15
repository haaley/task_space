import 'package:task_scape/common/UserData.dart';
import 'package:task_scape/controllers/meeting_page_controller.dart';
import 'package:task_scape/controllers/new_meeting_page_controller.dart';
import 'package:task_scape/model/guestProvider.dart';
import 'package:task_scape/utils/dialogsWidget.dart';
import 'package:task_scape/views/home_page/home_page.dart';
import 'package:task_scape/views/new_meeting_page/widgets/addGuestWidgets/guestTileWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final GlobalKey<State> _keyLoader = new GlobalKey<State>();


Widget GuestListEdit(GuestModel guestList, int meeting, BuildContext context, int tab) {

  return SingleChildScrollView(
    child: new Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: new ListView.builder(
            itemCount: guestList.guestList.length,
            padding: new EdgeInsets.only(top: 5.0, bottom: 2.0),
            itemBuilder: (context, index) {
              NewMeetingPageController.instance.status.value.clear();
              guestList.guestList.forEach((element) {
                NewMeetingPageController.instance.status.value.add(element.status);
              });
              return Slidable(
                key: Key(guestList.guestList[index].id.toString()),
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                dismissal: SlidableDismissal(
                  child: SlidableDrawerDismissal(),
                  dismissThresholds: <SlideActionType, double>{
                    SlideActionType.secondary: 1.0,
                    SlideActionType.primary: 0.0
                  },
                  onWillDismiss: (actionType) {
                    return showDialog<bool>(
                      context: context,
                      builder: (context) {
                        if (guestList.guestList.length > 1 && guestList.guestList[index].status != "AUTHOR" && guestList.guestList[index].id != UserData().id) {
                          return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                        title: Icon(Icons.info, size: 56.0, color: Colors.orange,),
                            content: Text("Deseja remover este convidado?"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () async {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    Dialogs.showLoadingDialog(
                                        context, _keyLoader, "Removendo...");
                                    await MeetingPageController.instance.deleteGuest(
                        guestList.guestList[index].self);
                        guestList.guestList.remove(index);
                                    Navigator.of(_keyLoader.currentContext,
                                        rootNavigator: true)
                                        .pop();
                                  },
                                  child: Text("Sim")),
                              FlatButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("Cancelar"),
                              ),
                            ],
                          );
                        } else {
                          return AlertDialog(
                            title: const Text("Atenção"),
                            content: Text(guestList.guestList[index].status == "AUTHOR"?
                            "Não é possível remover um autor.": guestList.guestList[index].id == UserData().id ? "Não é possível se remover da reunião.":"Não é possível remover todos os convidados."),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("Ok"),
                              ),
                            ],
                          );
                        }
                      },
                    );
                  },
                ),
                actions: <Widget>[
                  IconSlideAction(
                    caption: 'Remover',
                    color: Colors.redAccent,
                    icon: Icons.delete_forever,
                    onTap: () {},
                  ),
                ],
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: guestList.guestList[index].status == "AUTHOR" ? "Convidado" : "Autor",
                    foregroundColor: Colors.white,
                    color: guestList.guestList[index].status == "AUTHOR" ? Colors.orange : Colors.green,
                    iconWidget: Icon(guestList.guestList[index].status == "AUTHOR" ? Icons.person: Icons.edit, color: Colors.white),
                    onTap: () async {
                      if(guestList.guestList[index].status == "GUEST_EXTERNAL"){
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 2), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                backgroundColor: Colors.black54,
                                title: Text(
                                  'Erro',
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: Text(
                                    "Impossível tornar convidado externo autor.",
                                    style: TextStyle(color: Colors.white)),
                              );
                            });

                      }
                      else if(guestList.guestList[index].id == MeetingPageController.instance.idAuthor){
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 2), () {
                                Navigator.of(context).pop(true);
                              });
                              return AlertDialog(
                                backgroundColor: Colors.black54,
                                title: Text(
                                  'Erro',
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: Text(
                                    "Impossível modificar status do criador da reunião.",
                                    style: TextStyle(color: Colors.white)),
                              );
                            });
                      }
                      else{
                        int value =guestList.guestList[index].status == "AUTHOR" ? 1 : guestList.guestList[index].status == "GUEST" ? 0 : 2;

                        Dialogs.showLoadingDialog(
                            context, _keyLoader, "Salvando...");

                        var answ =
                        await MeetingPageController.instance.updateGuest(guestList.guestList[index].self, value);
                        print(answ.toString());
                        Navigator.of(_keyLoader.currentContext,
                            rootNavigator: true)
                            .pop();

                        if (answ.toString() == '200') {
                          MeetingPageController.instance.status.value[index] = value == 0 ? "AUTHOR":value == 1?"GUEST":"GUEST_EXTERNAL";
                          guestList.guestList[index].status = value == 0 ? "AUTHOR":value == 1?"GUEST":"GUEST_EXTERNAL";
                          guestList.notifyListeners();
                          MeetingPageController.instance.status.notifyListeners();

                          if(guestList.guestList[index].id == UserData().id) {

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomePage(tab: tab)),
                                    (Route<dynamic> route) => false);

                          }
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

                      }


                    },
                  ),
                ],
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(10.0)),
                  margin: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10.0, top: 5.0),

                  child: new Material(
                      borderRadius: new BorderRadius.circular(6.0),
                      elevation: 2.0,
                      child: SingleChildScrollView(
                        child: GuestListTile(guestList, index),
                      )),
                ),
              );
            })),
  );
}