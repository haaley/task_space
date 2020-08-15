import 'package:task_scape/controllers/meeting_page_controller.dart';
import 'package:task_scape/model/guestProvider.dart';
import 'package:task_scape/views/meeting_page/widgets/guestListWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

final f = new DateFormat('dd/MM/yyyy HH:mm');


Widget MeetingDescription(BuildContext context, Map<String, dynamic> meeting){
  return Material(
    child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Center(
              child: Container(
                margin: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0, top: 15.0),
                child: Text(
                  meeting['title'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              )),
          Container(
            decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(10.0),
                color: Colors.grey[200]),
            margin: const EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 10.0, top: 5.0),
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                        child: Linkify(
                          text: meeting['description'],
                          style:
                          new TextStyle(fontSize: 15.0, color: Colors.black),
                          options: LinkifyOptions(humanize: false),
                          linkStyle: TextStyle(color: Colors.blue),
                          onOpen: (link) async {
                            if (await canLaunch(link.url)) {
                              await launch(link.url);
                            } else {
                              throw 'Could not launch $link';
                            }
                          },
                        )),
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Text(f.format(DateTime.parse(meeting['data']))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Criador: ${meeting['author']}'),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Local: ${meeting['localMeeting']}'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Consumer<GuestModel>(builder: (context, guest, child) {
              MeetingPageController.instance.status.value.clear();

              guest.guestList.forEach((element) {
                print("status ${element.id}");
                MeetingPageController.instance.status.value.add(element.status);
              });
              return _body(context, guest, child);
            }),
          )
        ],
      ),
    ),
  );
}


showLoadingDialog(List conv) {
  return conv.isEmpty;
}

_body(BuildContext context, GuestModel guests, child) {
  if (showLoadingDialog(guests.guestList)) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  } else {
    return GridView.builder(
        primary: false,
        padding: const EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 2),
            mainAxisSpacing: 10),
        itemCount: guests.guestList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 10.0,
              child: InkWell(
                  splashColor: Colors.blue,
                  child: Container(
                    child: GuestListWidget(guests, index),
                  )));
        });
  }
}
