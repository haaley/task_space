import 'package:task_scape/common/UserData.dart';
import 'package:task_scape/controllers/meeting_page_controller.dart';
import 'package:task_scape/model/meetingAgendaProvider.dart';
import 'package:task_scape/views/home_page/home_page.dart';
import 'package:task_scape/views/meeting_page/widgets/floatingButtonsWidget.dart';
import 'package:task_scape/views/meeting_page/widgets/meetingDescriptionWidget.dart';
import 'package:task_scape/views/meeting_page/widgets/staticMeetingAgendaListWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MeetingPage extends StatefulWidget {

  final id;
  final type;
  final meeting;
  final void Function(int) backTab;

  const MeetingPage(
      {Key key, this.id, this.type, this.meeting, this.backTab}) : super(key: key);

  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: backButton,
      child: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    title: Text('Dados da Reunião'),
                    pinned: true,
                    backgroundColor: Color.fromRGBO(0, 99, 170, 1),
                    floating: true,
                    leading: new IconButton(
                      icon: new Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context)
                          .pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(tab: widget.type)),
                              (Route<dynamic> route) => false),
                    ),
                    forceElevated: innerBoxIsScrolled,
                    bottom: TabBar(
                      tabs: [
                        Tab(
                            icon: Icon(
                              Icons.dehaze,
                              size: 30,
                            ),
                            text: 'Detalhes'),
                        Tab(
                            icon: Icon(Icons.library_books, size: 30),
                            text: 'Pautas'),
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                MeetingDescription(context, widget.meeting),
                  Consumer<MeetingAgendaProvider>(
                      builder: (context, meetingAgenda, child)=>
                      (widget.meeting['idAuthor'] == UserData().id  || MeetingPageController.instance.isAuthor &&
                          widget.type != 0
                          ? MeetingPageController.instance.listAgendaMeeting(
                          meetingAgenda, widget.meeting['idMeeting'],widget.type)
                          :StaticMeetingAgendaList(
                          meetingAgenda, widget.meeting['idMeeting'])),
                  )
                ],
              ),
            ),
          floatingActionButton: Stack(children: [
            FloatingActionButtons(context,widget.type, widget.meeting)
          ],),

        ),
      )
    );
  }

  Future<bool> backButton() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Text(
          'Atenção',
          textAlign: TextAlign.center,
        ),
        content: Text('Deseja sair dessa Reunião?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => HomePage(tab: widget.type)),
                      (Route<dynamic> route) => false);
              widget.backTab(widget.type);
            },
            child: new Text('Sim'),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Não'),
          ),
        ],
      ),
    ) ??
        false;
  }

}

