import 'package:task_scape/controllers/meeting_page_controller.dart';
import 'package:task_scape/model/meetingAgendaProvider.dart';
import 'package:task_scape/utils/dialogsWidget.dart';
import 'package:task_scape/views/meeting_page/widgets/alertDialogWidget.dart';
import 'package:task_scape/views/meeting_page/widgets/editMeetingAgendaWidget.dart';
import 'package:task_scape/views/meeting_page/widgets/showMeetingAgendaAlertWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final GlobalKey<State> _keyLoader = new GlobalKey<State>();

Widget MeetingAgendaList(MeetingAgendaProvider meetingAgenda, int id){

  return new Container(
      height: 75.0 + 75.0 * meetingAgenda.meetingAgendaList.length,
      child: new ListView.builder(
          itemCount: meetingAgenda.meetingAgendaList.length,
          padding: new EdgeInsets.only(top: 5.0),
          itemBuilder: (BuildContext context, int index) {
            meetingAgenda.meetingAgendaList.forEach((element) {
              MeetingPageController.instance.statusMeetingAgenda.value.add(element.status);
            });
            return Slidable(
                key: Key(meetingAgenda.meetingAgendaList[index].title),
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
                        if(meetingAgenda.meetingAgendaList.length>1){
                          return DeleteAlertDialog(context, meetingAgenda, index);
                        }
                        else{
                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.of(context).pop(false);
                          });
                          return AlertDialog(
                            backgroundColor: Colors.black54,
                            title: Text('Atenção', style: TextStyle(color: Colors.white),),
                            content: Text("Não é possível remover todas as pautas.", style: TextStyle(color: Colors.white)),
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
                    caption: 'Editar',
                    foregroundColor: Colors.white,
                    color: Colors.green,
                    iconWidget: Icon(Icons.edit, color: Colors.white),
                    onTap: () {
                      EditMeetingAgenda(
                          context,
                          meetingAgenda.meetingAgendaList[index].title,
                          meetingAgenda.meetingAgendaList[index].description == null
                              ? ""
                              : meetingAgenda.meetingAgendaList[index].description,
                          index, meetingAgenda.meetingAgendaList[index].status,
                          meetingAgenda.meetingAgendaList[index].self);
                    },
                  ),
                ],
                child: Container(
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
                          leading: ValueListenableBuilder(
                            valueListenable: MeetingPageController.instance.statusMeetingAgenda,
                            builder:(context, value, child){
                              return CircleAvatar(
                                child: IconButton(
                                  icon: ValueListenableBuilder(
                                    valueListenable: MeetingPageController.instance.statusMeetingAgenda,
                                    builder: (context, value, child){
                                      return Icon(value[index] == 0 ? Icons.warning:Icons.check);
                                    },
                                  ),
                                  onPressed: ()async{
                                    Map<String, dynamic> newPauta = Map();
                                    newPauta["title"] = meetingAgenda.meetingAgendaList[index].title;
                                    newPauta["description"] = meetingAgenda.meetingAgendaList[index].description;

                                    if(MeetingPageController.instance.statusMeetingAgenda.value[index] == 0){
                                      MeetingPageController.instance.statusMeetingAgenda.value[index]= 1;
                                      newPauta["status"] = 1;
                                    }
                                    else{
                                      MeetingPageController.instance.statusMeetingAgenda.value[index]= 0;
                                      newPauta["status"] = 0;
                                    }

                                    Dialogs.showLoadingDialog(
                                        context, _keyLoader, "Salvando...");

                                    List answ =
                                    await MeetingPageController.instance.editAgendaMeeting(newPauta, meetingAgenda.meetingAgendaList[index].self);
                                    Navigator.of(_keyLoader.currentContext,
                                        rootNavigator: true)
                                        .pop();

                                    if (answ[0] == '200') {
                                      MeetingPageController.instance.updateMeetingAgenda(context,meetingAgenda.meetingAgendaList[index].title,
                                          meetingAgenda.meetingAgendaList[index].description,newPauta['status'], index);
                                      MeetingPageController.instance.statusMeetingAgenda.notifyListeners();

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
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: value[index]== 0 ? Colors.orange : Colors.green,
                              );
                            },
                          ),
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
                            showMeetingAgendaAlert(context, meetingAgenda.meetingAgendaList, index);
                          },
                          onLongPress: () {
                            return showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  Clipboard.setData(new ClipboardData(text: meetingAgenda.meetingAgendaList[index].title + "\n" + (meetingAgenda.meetingAgendaList[index].description == null ? "" : meetingAgenda.meetingAgendaList[index].description) ));
                                  Future.delayed(Duration(seconds: 3), () {
                                    Navigator.of(context).pop(false);
                                  });
                                  return AlertDialog(
                                    backgroundColor: Colors.black54,
                                    title: Text('Sucesso', style: TextStyle(color: Colors.white),),
                                    content: Text("Texto copiado para área de transferência.", style: TextStyle(color: Colors.white)),
                                  );
                                }
                            );
                          },
                        ),
                      )),
                ));
          }));
}