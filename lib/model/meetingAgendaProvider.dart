import 'dart:collection';
import 'package:task_scape/model/meetingAgenda.dart';
import 'package:task_scape/services/meetingPageService.dart';
import 'package:flutter/cupertino.dart';

class MeetingAgendaProvider with ChangeNotifier{

  final List<MeetingAgenda> _meetingAgendaList = [];

  UnmodifiableListView<MeetingAgenda> get meetingAgendaList => UnmodifiableListView(_meetingAgendaList);

  int get qtdMeetingAgendaList => _meetingAgendaList.length;

  void addMeetingAgenda(MeetingAgenda meetingAgenda){
    _meetingAgendaList.add(meetingAgenda);
    notifyListeners();
  }

  void addNewMeetingAgenda(Map<String, dynamic> meetingAgenda){
    _meetingAgendaList.add(MeetingAgenda(title: meetingAgenda['title'], description: meetingAgenda['description']));
    notifyListeners();
  }

  void editMeetingAgenda(String title, String description, int status, int index){
    MeetingAgenda oldMeetingAgenda = _meetingAgendaList[index];
    oldMeetingAgenda.title = title;
    oldMeetingAgenda.description = description;
    oldMeetingAgenda.status = status;
    notifyListeners();
  }

  void removeMeetingAgenda(int index){
    _meetingAgendaList.removeAt(index);
    notifyListeners();
  }

  void removeAllMeetingAgenda(){
    _meetingAgendaList.clear();
  }

  List<Map<String,dynamic>> getListofMeetingAgenda(){
    Map<String, dynamic> meetingAgenda = {};
    List<Map<String,dynamic>> meetingAgendaList = [];

    _meetingAgendaList.forEach((element) {
      meetingAgenda['title'] = element.title;
      meetingAgenda['description'] = element.description;
      meetingAgenda['status'] = element.status;
      meetingAgendaList.add(meetingAgenda);
    });

    return meetingAgendaList;
  }

  void loadMeetingAgendas(String url) async{
    List meetingAgendaList = [];
    meetingAgendaList = await MeetingPageService.instance.loadMeetingAgenda(url);
    meetingAgendaList.forEach((element) {
      addMeetingAgenda(MeetingAgenda.fromJson(element));
    });
  }
}