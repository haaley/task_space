import 'package:task_scape/common/UserData.dart';
import 'package:task_scape/model/guestProvider.dart';
import 'package:task_scape/model/meetingAgenda.dart';
import 'package:task_scape/model/meetingAgendaProvider.dart';
import 'package:task_scape/services/meetingPageService.dart';
import 'package:task_scape/utils/dialogsWidget.dart';
import 'package:task_scape/views/meeting_page/widgets/meetingAgendaListAuthorWidget.dart';
import 'package:task_scape/views/meeting_page/widgets/meetingAgendaListWidget.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';


class MeetingPageController{
  static final MeetingPageController instance = MeetingPageController._();

  MeetingPageController._();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  bool isAuthor;
  String startURL;
  String endURL;
  String cancel;
  String add_meetingAgenda;
  String add_guest;
  String startDate;
  String endDate;
  int idAuthor;

  ValueNotifier<List<String>> status = new ValueNotifier([]);
  ValueNotifier<List<int>> statusMeetingAgenda = new ValueNotifier([]);
  TextEditingController titlecontroller = new TextEditingController();
  TextEditingController descriptioncontroller = new TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Map<String, dynamic> meeting;

  void setMeeting(Map<String, dynamic> meeting){
    meeting = meeting;
    print(meeting.toString());
  }

  loadGuest(BuildContext context, String url) {
    Provider.of<GuestModel>(context, listen: false).loadGuests(url);
  }

  void loadMeetingAgenda(BuildContext context, String url) {
    return Provider.of<MeetingAgendaProvider>(context, listen: false).loadMeetingAgendas(url);
  }

  void resetMeetingAgenda(BuildContext context) {
    Provider.of<MeetingAgendaProvider>(context, listen: false).removeAllMeetingAgenda();
  }

  void resetGuestList(BuildContext context){
    Provider.of<GuestModel>(context, listen: false).removeAllGuests();
  }

  void addNewMeetingAgenda(BuildContext context,Map<String,dynamic> meetingAgenda) {
    Provider.of<MeetingAgendaProvider>(context, listen: false).addNewMeetingAgenda(meetingAgenda);
  }

  void updateMeetingAgenda(BuildContext context, String title, String description, int status, int index) {
    Provider.of<MeetingAgendaProvider>(context, listen: false).editMeetingAgenda(title, description, status, index);
  }

  Widget listAgendaMeeting(MeetingAgendaProvider meetingAgenda, int id, int type) {
    statusMeetingAgenda.value.clear();

    if (showLoadingDialog(meetingAgenda.meetingAgendaList)) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else if(type == 0){
      return MeetingAgendaListAuthor(meetingAgenda,id);
    }else {
      return MeetingAgendaList(meetingAgenda, id);
    }
  }

  void checkAuthor(String url) async{
    List guests = await MeetingPageService.instance.loadGuests(url);

    bool answ = false;
    guests.forEach((element) {
      if(element['id'] == UserData().id) {
        if (element['status'] == "AUTHOR") {
          answ = true;
        }
      }
    });

    isAuthor = answ;
  }

  bool showLoadingDialog(List meetingAgendas) {
    return meetingAgendas.isEmpty;
  }

  Future<List> editAgendaMeeting (Map<String, dynamic> data, String url) async{
    return await MeetingPageService.instance.editAgendaMeeting(data, url);
  }

  Future<void> deleteMeetingAgenda(String url) async{
    await MeetingPageService.instance.deleteMeetingAgenda(url);
  }

  void exportPdf(int id) async {
    String dirloc = (await getExternalStorageDirectory()).path;
    await MeetingPageService.instance.exportPDF(id);
    final messsage =
    await OpenFile.open(dirloc + "/ata_" + id.toString() + ".pdf");
  }

  Future<int> updateMeeting(String url) async{
    print(url);
    return await MeetingPageService.instance.updateMeeting(url);
  }

  void loadActions(BuildContext context, String url) async{
    var answer = await MeetingPageService.instance.loadMeeting(url);
    try {
      startURL = answer['_links']['start_meeting']['href'];
      endURL = answer['_links']['finish_meeting']['href'];
      cancel = answer['_links']['cancel_meeting']['href'];
      add_meetingAgenda = answer['_links']['add_agenda']['href'];
      add_guest = answer['_links']['add_guest']['href'];
      startDate = answer['startExpected'];
      endDate = answer['endExpected'];
      idAuthor = answer['author']['id'];
    } catch (e) {
      print("erro");
    }
  }

  void addMeetingAgenda(BuildContext context, int id, Map<String, dynamic> newMeetingAgenda) async {
    try {
      Dialogs.showLoadingDialog(context, _keyLoader, "Salvando...");
      var resp = await MeetingPageService.instance.addMeetingAgenda(MeetingPageController.instance.add_meetingAgenda, newMeetingAgenda);
      Navigator.of(context, rootNavigator: true).pop();
      print('resp ${resp}');
      if (resp[0] == '201') {
        var body = resp[1]['idAgenda'];
        newMeetingAgenda['id'] = body;
        newMeetingAgenda['self'] = resp[1]['_links']['self']['href'];
        print("pauta: " + newMeetingAgenda.toString());
        addNewMeetingAgenda(context, newMeetingAgenda);
        Navigator.of(context, rootNavigator: true).pop('dialog');
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
                content: Text("Erro de conexão. Tente novamente.",
                    style: TextStyle(color: Colors.white)),
              );
            });
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> addGuestEdit(BuildContext context, String  url, Map<String,dynamic> data) async{
    await MeetingPageService.instance.addGuest(url, data);
  }

  Future<void> deleteGuest(String url) async{
    await MeetingPageService.instance.deleteGuest(url);
  }

  Future<int> updateGuest(String url,int value) async{
    return await MeetingPageService.instance.updateGuest(url, value);
  }

}