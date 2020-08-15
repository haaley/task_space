import 'package:task_scape/model/guestProvider.dart';
import 'package:task_scape/model/meetingAgendaProvider.dart';
import 'package:task_scape/views/login_page/login_page.dart';
import 'package:task_scape/utils/globalScaffold.dart';
import 'package:task_scape/views/meeting_page/meeting_page.dart';
import 'package:task_scape/views/new_meeting_page/new_meeting_page.dart';
import 'package:task_scape/views/splash_page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GuestModel()),
        ChangeNotifierProvider(create: (context) => MeetingAgendaProvider(),
        )
      ],
      child:  MaterialApp(
        title: 'SEFAZ Reuniões',
        builder: (context, child){
          return Scaffold(
            key: GlobalScaffold.instance.scaffoldKey,
            body: child,
          );
        },
        routes:<String,WidgetBuilder>{
          "LoginScreen": (BuildContext context) => LoginPage(),
          "NewMeeting": (BuildContext context) => NewMeetingPage(),
          "MeetingPage": (BuildContext context) => MeetingPage()
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}