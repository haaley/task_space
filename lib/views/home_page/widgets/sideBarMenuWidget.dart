import 'package:task_scape/common/UserData.dart';
import 'package:task_scape/services/loginPageService.dart';
import 'package:task_scape/views/home_page/widgets/aboutAlertWidget.dart';
import 'package:task_scape/views/login_page/login_page.dart';
import 'package:flutter/material.dart';

Widget SideBarMenuWidget(BuildContext context,
    String appName,
    String apiVersion,
    String version){
  return Column(
    children: <Widget>[
      Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("${UserData().nickname}"),
              accountEmail: Text("${UserData().email}"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                    ? Colors.blue
                    : Colors.white,
                child: Text(
                  "${UserData().email.substring(0,1).toUpperCase()}",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Reuniões'),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Sobre'),
              onTap: (){
                AboutAlertWidget(context, appName, apiVersion, version);
              },
            ),
          ],
        ),
      ),
      Container(
        // This align moves the children to the bottom
          child: Align(
              alignment: FractionalOffset.bottomCenter,
              // This container holds all the children that will be aligned
              // on the bottom and should not scroll with the above ListView
              child: Container(
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Sair'),
                        onTap: (){
                          storage.delete(key: "token");
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                                  (Route<dynamic> route) => false);
                        },
                      )
                    ],
                  )
              )
          )
      )
    ],
  );
}