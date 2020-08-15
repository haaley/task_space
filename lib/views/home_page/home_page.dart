import 'package:task_scape/controllers/home_page_controller.dart';
import 'package:task_scape/views/home_page/widgets/meetingListWidget.dart';
import 'package:task_scape/views/home_page/widgets/sideBarMenuWidget.dart';
import 'package:task_scape/views/home_page/widgets/tabBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List temp = [];
List result = [];
List past = [];
List now = [];
List future = [];
ScrollController _scrollViewController;
String appname = "";
String _searchText = "";
String version = "";
String apiversion = "";
List time = [];
Widget _title = Text("Reuniões");
Icon _searchIcon = new Icon(Icons.search);
Icon _filterIcon = new Icon(FontAwesomeIcons.filter, size: 16.0,);
TabController tabControl;
bool erro;
bool pend_filter =false;

final TextEditingController _filter = new TextEditingController();

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.tab}) : super(key: key);
  final String title;
  final int tab;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _HomePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          print(_filter.text);
          _searchText = _filter.text;
        });
      }
    });
  }

  _backTab(int index) {
    print("index : $index");
    setState(() {
      tabControl.index = index;
      tabControl.animateTo(tabControl.index);
    });
  }

  _load() async {
    time = [];
    temp = await HomePageController.instance.loadMeetings();
    time = ['ok'];
    erro = false;
    if (temp[0] == 400) {
      erro = true;
    } else {
      result = temp;
    }

    if (erro) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text('Erro ao atualizar. Verifique sua conexão e tente novamente.'),
        duration: Duration(seconds: 3),
      ));
    }
    setState(() {
      now.clear();
      past.clear();
      future.clear();

      List filteredMeetings =
          HomePageController.instance.filteringMeetings(result);

      past = filteredMeetings[0];
      now = filteredMeetings[1];
      future = filteredMeetings[2];
    });
  }

  showLoadingDialog() {
    return time.isEmpty;
  }

  _body() {
    List filtered = [];
    if (showLoadingDialog()) {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      filtered =
          HomePageController.instance.filteredSearchResult(_searchText, result);
    }

    setState(() {
      now.clear();
      past.clear();
      future.clear();
      filtered.forEach((e) {
        String data =
            e['startExpected'].replaceAll('T', ' ').replaceAll("Z", '');
        DateTime startDate = DateTime.parse(data);

        if (startDate.day == DateTime.now().day &&
            startDate.month == DateTime.now().month &&
            startDate.year == DateTime.now().year &&
            e['status'] != "FINISHED" && e['status'] != "CANCELED") {
          now.add(e);
        }

        else if (startDate.isBefore(DateTime.now()) &&
            DateTime.now().difference(startDate).inDays > 0 && e['status'] != "CANCELED"||
            e['status'] == "FINISHED") {
          past.add(e);
        }

        else if (startDate.isAfter(DateTime.now()) &&
            startDate.difference(DateTime.now()).inHours > 0 &&
            e['status'] == "SCHEDULED") {
          future.add(e);
        }
      });
    });

    return TabBarView(
      children: [
        MeetingList(
            result: filtered, type: 0, parentAction: _load, backTab: _backTab),
        MeetingList(
            result: filtered, type: 1, parentAction: _load, backTab: _backTab),
        MeetingList(
            result: filtered, type: 2, parentAction: _load, backTab: _backTab),
      ],
      controller: tabControl,
    );
  }

  @override
  void initState() {
    super.initState();
    now.clear();
    tabControl = new TabController(length: 3, vsync: this);
    if (widget.tab != null) {
      _backTab(widget.tab);
    } else {
      tabControl.index = 1;
    }
    HomePageController.instance.getVersionNumber();
    past.clear();
    future.clear();
    _scrollViewController = new ScrollController();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: tabControl.index,
        length: 3,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: SideBarMenuWidget(context, "Atas", "1.0.0", "3.0.0"),
          ),
          body: new NestedScrollView(
            controller: _scrollViewController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  title: _title,
                  backgroundColor: Color.fromRGBO(0, 99, 170, 1),
                  centerTitle: true,
                  pinned: true,
                  floating: true,
                  actions: <Widget>[
                    IconButton(
                      icon: _filterIcon,
                      onPressed: (){
                        setState(() {
                          _filterIcon = pend_filter ? Icon(FontAwesomeIcons.filter, size: 16.0,):Icon(Icons.backspace, size: 19.0,);
                          pend_filter = !pend_filter;
                        });
                      },

                    ),
                    IconButton(
                      icon: _searchIcon,
                      onPressed: () {
                        setState(() {
                          if (_searchIcon.icon == Icons.search) {
                            _searchIcon = Icon(Icons.close);
                            _title = new TextField(
                              controller: _filter,
                              style: TextStyle(color: Colors.white),
                              decoration: new InputDecoration(
                                prefixIcon: new Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          } else {
                            _searchIcon = new Icon(Icons.search);
                            _title = new Text('Reuniões');
                            _filter.clear();
                          }
                        });
                      },
                    ),
                  ],
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBarWidget(past,now,future, tabControl),
                ),
              ];
            },
            body: _body(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed("NewMeeting");
            },
            child: Icon(Icons.add),
            backgroundColor: Color.fromRGBO(0, 99, 170, 1),
            tooltip: 'Nova Reunião',
          ),
        ));
  }
}
