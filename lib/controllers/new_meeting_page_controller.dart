import 'package:task_scape/common/UserData.dart';
import 'package:task_scape/controllers/meeting_page_controller.dart';
import 'package:task_scape/model/guest.dart';
import 'package:task_scape/model/guestProvider.dart';
import 'package:task_scape/model/meetingAgenda.dart';
import 'package:task_scape/model/meetingAgendaProvider.dart';
import 'package:task_scape/model/userProvider.dart';
import 'package:task_scape/services/newMeetingPageService.dart';
import 'package:task_scape/utils/dialogsWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewMeetingPageController{
  static final NewMeetingPageController instance = NewMeetingPageController._();

  NewMeetingPageController._();

  Map<String, dynamic> data = new Map();

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final currentState = ValueNotifier<int>(0);
  final titleController = TextEditingController();
  final localController = TextEditingController();
  final descriptionController = TextEditingController();
  final startdateController = TextEditingController();
  final enddateController = TextEditingController();
  final titleMeetingAgendaController = TextEditingController();

  final String identifyStartDate = "startExpected";
  final String identifyTitle = "title";
  final String identifyLocal = "localMeeting";
  final String identifyDescription = "description";
  final String identifyEndDate = "endExpected";

  List filterd =[];
  List guestList = [];
  List meetingagendaList = [];

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  int idMeeting;
  String statusPost = "";
  final newformat = DateFormat("dd-MM-yyyy HH:mm.sss");

  ValueNotifier<List<String>> status = new ValueNotifier([]);

  void initValues(){
    data.clear();
    titleController.text = "";
    localController.text = "";
    descriptionController.text = "";
    startdateController.text = "";
    enddateController.text = "";
    currentState.value = 0;
    currentState.notifyListeners();
    titleMeetingAgendaController.text = "";
  }

  void convertData(String date, String type){
    List res = [];
    res = date.split(" ");
    data["${type}"] = res[0] + "T" + res[1] + "Z";
  }

  void onChagedDate(String type, DateTime newDate){
    if(type == identifyStartDate){
      startDate = newDate;
      if (startDate != null) {
        enddateController.text = newformat.format(startDate.add(Duration(hours: 1)));
      }
    }
    else{
      endDate = newDate;
    }
  }

  int validate(String type, DateTime date){
    if(type == identifyStartDate){
      if(date == null || date.isBefore(DateTime.now())){
        return 0;
      }
      else{
        return 1;
      }
    }
    else{
      if (date == null) {
        return 0;
      }
      else{
        Duration dif = date.difference(startDate);
        if (date.isBefore(DateTime.now()) ||
            date.isBefore(startDate) ||
            dif.inMinutes < 60 ||
            dif.inHours > 6 || startDate.day != endDate.day) {
          return 2;
        }
      }
    }
  }

  void saveInfo(String info, String identify){
    data["$identify"] = info;
  }

  void saveGuest(BuildContext context){
    Map<String, dynamic> author = Map();
    author["id"] = UserData().id;
    author["status"] = 0;
    List guests_aux = getListGuest(context);
    guests_aux.add(author);
    data['guestList'] = guests_aux;
  }

  void saveMeetingAgenda(BuildContext context){
    data['agendaList'] = getListMeetingAgenda(context);
  }

  List getListGuest(BuildContext context){
    return Provider.of<GuestModel>(context, listen: false).getList();
  }

  List getListMeetingAgenda(BuildContext context){
    return Provider.of<MeetingAgendaProvider>(context, listen: false).getListofMeetingAgenda();
  }

  void resetPauta(BuildContext context) {
    Provider.of<MeetingAgendaProvider>(context, listen: false).removeAllMeetingAgenda();
  }

  void resetConvidados(BuildContext context) {
    Provider.of<GuestModel>(context, listen: false).removeAllGuests();
  }


  void validateInfo(){
    if (formkey.currentState.validate()) {
        formkey.currentState.save();
        currentState.value += 1;
        currentState.notifyListeners();
    }
  }



  List getListaUsuarios(String _searchText) {
    List filtered = new List();

    if (UserViewModel.users.isEmpty) {
      return [];
    } else {
      if (_searchText.isEmpty) {
        filtered.clear();
        UserViewModel.users.forEach((element) {
          filtered.add(element);
        });
        UserViewModel.users
            .sort((a, b) => a.fullname.compareTo(b.fullname));
        return filtered;
      } else {
        filtered.clear();
        UserViewModel.users.forEach((element) {
          if (element.fullname
              .toLowerCase()
              .contains(_searchText.toLowerCase()) ||
              element.email.contains(_searchText.toLowerCase())) {
            filtered.add(element);
            print(element);
          }
        });
        if (filtered.isNotEmpty) {
          return filtered;
        } else {
          return [0];
        }
      }
    }
  }


  Widget addGuests(BuildContext context, String name, String email, int id,
      bool conflict) {
    //Provider.of.add();
    bool flag = Provider.of<GuestModel>(context, listen: false).addGuest(Guest(
        id: id,
        name: name,
        email: email,
        conflict: conflict,
        status: "GUEST"));
    if (flag) {
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 1), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              backgroundColor: Colors.black54,
              title: Text(
                'Sucesso',
                style: TextStyle(color: Colors.white),
              ),
              content: Text("Convidado adicionado com sucesso.",
                  style: TextStyle(color: Colors.white)),
            );
          });
    } else {
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
              content: Text("Convidado já foi adicionado.",
                  style: TextStyle(color: Colors.white)),
            );
          });
    }
  }

  Future<Widget> addGuestEdit(BuildContext context, String name, String email, int id,
      bool conflict, String url) async{
    bool flag = Provider.of<GuestModel>(context, listen: false).addGuest(Guest(
        id: id,
        name: name,
        email: email,
        conflict: conflict,
        status: "GUEST",
        self: MeetingPageController.instance.add_guest+ "/${id}"));
    if (flag) {
      Map<String, dynamic> newguest = Map();
      newguest["id"] = id;
      newguest["status"] = 1;
      print("neu guest "+newguest.toString());
      Dialogs.showLoadingDialog(context, _keyLoader, "Adicionando...");
      await MeetingPageController.instance.addGuestEdit(context, url, newguest);

      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 1), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              backgroundColor: Colors.black54,
              title: Text(
                'Sucesso',
                style: TextStyle(color: Colors.white),
              ),
              content: Text("Convidado adicionado com sucesso.",
                  style: TextStyle(color: Colors.white)),
            );
          });
      Navigator.of(context).pop();

    } else {
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
              content: Text("Convidado já foi adicionado.",
                  style: TextStyle(color: Colors.white)),
            );
          });
    }

  }

  void addMeetingAgenda(BuildContext context, MeetingAgenda meetingAgenda) {
    //Provider.of.add();
    Provider.of<MeetingAgendaProvider>(context, listen: false)
        .addMeetingAgenda(MeetingAgenda(title: meetingAgenda.title, description: meetingAgenda.description, status: 0));
  }

  void newMeetingPost(BuildContext context) async{
    List response = await NewMeetingPageService.instance.newMeeting(data);
    statusPost = response[0].toString();
    if (status == "400") {
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
    else {
      try {
        idMeeting = response[1];
      } catch (e) {
        print(e);
      }
    }
  }

  Future<int> sendEmail() async{

    return await NewMeetingPageService.instance.sendEmail(idMeeting);
  }

  Future<Map<String,dynamic>> outsideGuest(Map<String,dynamic> guest) async{
    return await NewMeetingPageService.instance.addOutsideGuest(guest);
  }

  addOutGuest(BuildContext context, Map<String, dynamic> guest) {
    //Provider.of.add();
    bool flag = Provider.of<GuestModel>(context, listen: false).addGuest(Guest(
        id: guest['id'],
        name: guest['name'],
        email: guest['email'],
        conflict: false,
        status: "GUEST_EXTERNAL"));
  }


  Future getDataMeeting(String url) async{
    guestList = [];
    meetingagendaList = [];
    List newguestList = [];
    List newPautas = [];
    var map = {};
    var result = await NewMeetingPageService.instance.loadMeeting(url);

    print(result.toString());

    titleController.text = result[identifyTitle] + " (Cópia)";
    localController.text = result[identifyLocal];
    descriptionController.text = result[identifyDescription];
    newguestList = result['guestResponseList'];

    guestList = [];
    newguestList.forEach((element) {
      Map guest = new Map();
      guest['id'] = element['id'];
      guest['status'] = element['status'] == 'GUEST' ? 1 : element['status'] == 'AUTHOR' ? 0 : 2;
      guestList.add(guest);
      print(guest.toString());
    });

    meetingagendaList= [];

    newPautas = result["agendaResponseList"];
    newPautas.forEach((element) {
      print(element.toString());
      map = {};
      map['title'] = element["title"];
      map['description'] = element["description"];
      map['status'] = 1;
      meetingagendaList.add(map);
    });
    print(meetingagendaList.length);
    final f = new DateFormat('dd-MM-yyyy HH:mm.sss');
    startDate = DateTime.parse(result[identifyStartDate]);
    endDate = DateTime.parse(result[identifyEndDate]);
    startdateController.text = f.format(startDate);
    enddateController.text = f.format(endDate);
  }

  void CopyMeetingPost(BuildContext context) async{
    statusPost = "";
    Dialogs.showLoadingDialog(context, _keyLoader, "Salvando...");
    await NewMeetingPageService.instance.newMeeting(data);
    Navigator.of(_keyLoader.currentContext,
        rootNavigator: true)
        .pop();
  }

  Future<int> EditMeetingPost(Map<String, dynamic> data, String url) async{
    return await NewMeetingPageService.instance.editMeeting(data, url);
  }

}