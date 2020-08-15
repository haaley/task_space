import 'package:task_scape/model/guestProvider.dart';
import 'package:task_scape/views/new_meeting_page/widgets/addGuestWidgets/guestListWidget.dart';
import 'package:task_scape/views/new_meeting_page/widgets/addGuestWidgets/newGuestWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddGuestList extends StatefulWidget {

  @override
  _AddGuestListState createState() => _AddGuestListState();
}

class _AddGuestListState extends State<AddGuestList> {



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) => NewGuest()));
            },
            child: Icon(Icons.add),
          ),
        ),
        Center(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Convidados Adicionados",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            )),
        Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Consumer<GuestModel>(
              builder: (context, conv, child) =>
                  GuestList(conv, context)),
        )
      ],
    );
  }
}
