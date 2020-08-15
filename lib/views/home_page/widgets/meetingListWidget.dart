import 'package:task_scape/common/UserData.dart';
import 'package:task_scape/controllers/home_page_controller.dart';
import 'package:task_scape/controllers/meeting_page_controller.dart';
import 'package:task_scape/utils/dialogsWidget.dart';
import 'package:task_scape/views/home_page/widgets/meetingDescriptionWidget.dart';
import 'package:task_scape/views/meeting_page/meeting_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secury;
import 'package:intl/intl.dart';


final storage = new secury.FlutterSecureStorage();

final f = new DateFormat('dd/MM/yyyy HH:mm');
List newResult = [];
TextEditingController titlecontroller = new TextEditingController();
TextEditingController descriptioncontroller = new TextEditingController();
GlobalKey<FormState> _formkey = GlobalKey<FormState>();
final GlobalKey<State> _keyLoader = new GlobalKey<State>();
bool open = false;
String start;
String finish;
String add_agenda;
int _id;
bool downloading = false;

class MeetingList extends StatefulWidget {
  final List result;
  final int type;
  final void Function() parentAction;
  final void Function(int) backTab;

  const MeetingList(
      {Key key, this.result, this.type, this.parentAction, this.backTab})
      : super(key: key);

  getResult() {
    return this.result;
  }

  setResult(List res) {
    this.result.clear();
    res.forEach((e) {
      this.result.add(e);
    });
  }

  @override
  _MeetingListState createState() => _MeetingListState();
}

class _MeetingListState extends State<MeetingList> {
  List meetings = new List();

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    bool erro = false;
    newResult = await HomePageController.instance.loadMeetings();
    if (newResult[0] == 400) {
      erro = true;
      newResult = widget.result;
    }
    setState(() {
      widget.parentAction();
      widget.setResult(newResult);
      meetings.clear();
      loadNotices();
    });
    if (erro) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
        Text('Erro ao atualizar. Verifique sua conexão e tente novamente.'),
        duration: Duration(seconds: 3),
      ));
    }
    return null;
  }

  @override
  void didUpdateWidget(MeetingList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.result != widget.result &&
        oldWidget.result.length != widget.result.length) {
      initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _exitalert, child: Container(child: _getListViewWidget()));
  }

  Future<bool> _exitalert() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Text(
          'Atenção',
          textAlign: TextAlign.center,
        ),
        content: Text('Deseja sair do Aplicativo?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Não'),
          ),
          new FlatButton(
            onPressed: () {
            },
            child: new Text('Sim'),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  void initState() {
    setState(() {
      widget.parentAction();
      meetings.clear();
      loadNotices();
    });
  }

  loadNotices() async {
    setState(() {
      if (widget.type == 0) {
        widget.result
            .sort((a, b) => b['startExpected'].compareTo(a['startExpected']));
      } else {
        widget.result
            .sort((a, b) => a['startExpected'].compareTo(b['startExpected']));
      }
      widget.result.forEach((item) {
        String data =
        item['startExpected'].replaceAll('T', ' ').replaceAll("Z", '');
        DateTime startDate = DateTime.parse(data);

        if (widget.type == 1) {
          if (startDate.day == DateTime.now().day &&
              startDate.month == DateTime.now().month &&
              startDate.year == DateTime.now().year &&
              item['status'] != "FINISHED" && item['status'] != "CANCELED") {
            Map<String, dynamic> meeting = new Map();
            meeting['status'] = item['status'];
            meeting['title'] = item['title'];
            meeting['data'] = data;
            meeting['localMeeting'] = item['localMeeting'];
            meeting['description'] = item['description'];
            meeting['author'] = item['author']['nickname'];
            meeting['idAuthor'] = item['author']['id'];
            meeting['idMeeting'] = item['idMeeting'];
            meeting['self'] = item['_links']['self']['href'];
            meetings.add(meeting);
          }
        } else if (widget.type == 0) {
          if (startDate.isBefore(DateTime.now()) &&
              DateTime.now().difference(startDate).inDays > 0 && item['status'] != "CANCELED"||
              item['status'] == "FINISHED") {
            Map<String, dynamic> meeting = new Map();
            meeting['status'] = item['status'];
            meeting['title'] = item['title'];
            meeting['data'] = data;
            meeting['localMeeting'] = item['localMeeting'];
            meeting['description'] = item['description'];
            meeting['author'] = item['author']['nickname'];
            meeting['idAuthor'] = item['author']['id'];
            meeting['idMeeting'] = item['idMeeting'];
            meeting['self'] = item['_links']['self']['href'];
            meetings.add(meeting);
          }
        }  else if (startDate.isAfter(DateTime.now()) &&
            startDate.difference(DateTime.now()).inHours > 0 &&
            item['status'] == 'SCHEDULED' && !(startDate.day == DateTime.now().day &&
            startDate.month == DateTime.now().month &&
            startDate.year == DateTime.now().year)) {
          Map<String, dynamic> meeting = new Map();
          meeting['status'] = item['status'];
          meeting['title'] = item['title'];
          meeting['data'] = data;
          meeting['localMeeting'] = item['localMeeting'];
          meeting['description'] = item['description'];
          meeting['author'] = item['author']['nickname'];
          meeting['idAuthor'] = item['author']['id'];
          meeting['idMeeting'] = item['idMeeting'];
          meeting['self'] = item['_links']['self']['href'];
          meetings.add(meeting);
        }
      });
    });
  }

  Widget _getListViewWidget() {
    var list = new RefreshIndicator(
        child: meetings.isNotEmpty
            ? ListView.builder(
          itemCount: meetings.length,
          padding: new EdgeInsets.only(top: 5.0),
          itemBuilder: buildList,
        )
            : Container(
          child: Center(
            child: ListView(
              padding: EdgeInsets.fromLTRB(0.0, 200.0, 30.0, 0.0),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Sem Reuniões agendadas.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        onRefresh: _refresh);
    return list;
  }

  Widget buildList(context, index) {
    return GestureDetector(
        child: Container(
          margin: const EdgeInsets.only(
              left: 10.0, right: 10.0, bottom: 10.0, top: 5.0),
          child: new Material(
            borderRadius: new BorderRadius.circular(10.0),
            elevation: 2.0,
            child: new Container(
              decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0),
                  color: Colors.white),
              height: 200.0,
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 10.0,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                        gradient: LinearGradient(
                            colors: meetings[index]['status'] == 'FINISHED'
                                ? [Colors.blueGrey, Colors.grey]
                                : widget.type == 0
                                ? [
                              Colors.red,
                              Colors.redAccent
                            ]
                                : [Color.fromRGBO(0, 99, 170, 1), Colors.blue],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            tileMode: TileMode.clamp)),
                  ),
                  getColumText(meetings[index]['title'], meetings[index]['data'],
                      meetings[index]['description'], meetings[index]['author'],meetings[index]['status']),
                ],
              ),
            ),
          ),
        ),
        onTap: () async{
          MeetingPageController.instance.resetMeetingAgenda(context);
          MeetingPageController.instance.resetGuestList(context);
          Dialogs.showLoadingDialog(context, _keyLoader, "Carregando...");
          await MeetingPageController.instance.loadMeetingAgenda(context, meetings[index]['self']);
          await MeetingPageController.instance.checkAuthor(meetings[index]['self']);
          await MeetingPageController.instance.loadActions(context, meetings[index]['self']);
          await MeetingPageController.instance.loadGuest(context, meetings[index]['self']);
          MeetingPageController.instance.setMeeting(meetings[index]);
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MeetingPage(id: meetings[index]['idMeeting'], type: widget.type, meeting: meetings[index], backTab: widget.backTab)));
        },
      onLongPress: () async{
        Dialogs.showLoadingDialog(context, _keyLoader, "Carregando...");
        await MeetingPageController.instance.loadActions(context, meetings[index]['self']);
        Navigator.pop(context);
        if(meetings[index]['idAuthor'] == UserData().id && meetings[index]['status'] =="SCHEDULED"){
          return showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Atenção'),
                  content: Text('Você deseja cancelar esta reunião?'),
                  actions: <Widget>[
                    MaterialButton(
                        child: Text('Sim'),
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                          cancelMeeting();

                        }),
                    MaterialButton(
                      child: Text('Não'),
                      onPressed: (){
                        Navigator.of(context).pop(false);

                      },
                    ),
                  ],
                );
              }
          );

        }
        else{
          return showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.of(context).pop(true);
                });
                return AlertDialog(
                  backgroundColor: Colors.black54,
                  title: Text(
                    'Atenção',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Text(
                      "Somente o criador pode cancelar esta reunião.",
                      style: TextStyle(color: Colors.white)),
                );
              });
        }
      },
    );
  }

  cancelMeeting() async{
    Dialogs.showLoadingDialog(
        context, _keyLoader, "Cancelando...");
    var resp = await MeetingPageController.instance.updateMeeting(MeetingPageController.instance.cancel);
    Navigator.pop(context);
    String status = resp.toString();
    print(status + "status");

    if(status=='200'){
      print("ok");
      widget.parentAction();
      _refresh();
    }
    else{
      return showDialog(
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
                  "Erro de conexão. Tente novamente.",
                  style: TextStyle(color: Colors.white)),
            );
          });
    }

  }

}
