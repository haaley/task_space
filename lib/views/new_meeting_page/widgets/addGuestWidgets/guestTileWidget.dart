import 'package:task_scape/controllers/meeting_page_controller.dart';
import 'package:task_scape/model/guestProvider.dart';
import 'package:flutter/material.dart';

Widget GuestListTile(GuestModel conv, int index) {
  return new Container(
    height: 95.0,
    child: new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image(
          image: AssetImage('assets/avatar.png'),
          width: 95.0,
          height: 95.0,
        ),
        _getColumText(
          conv.guestList[index].name,
          conv.guestList[index].conflict ? 'Ocupado' : 'Disponivel',
          conv.guestList[index].email,
          conv.guestList[index].conflict,
          index
        ),
      ],
    ),
  );
}

Widget _getColumText(title, date, description, conflito, int index) {

  return new Expanded(
      child: new Container(
        margin: new EdgeInsets.all(10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _getTitleWidget(title, conflito, index),
            _getDateWidget(date),
            _getDescriptionWidget(description)
          ],
        ),
      ));
}

Widget _getTitleWidget(String title, bool conflito, int index) {
  return Row(
    children: [
      Expanded(
        child: Text(
          title,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              color: conflito ? Colors.red : Colors.black),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: ValueListenableBuilder(
          valueListenable: MeetingPageController.instance.status,
          builder: (context, value, child) {
            return Icon(value[index] == "AUTHOR" ? Icons.edit: Icons.person);
          },
        ),
      )
    ],
  );
}

Widget _getDescriptionWidget(String description) {
  return new Container(
    margin: new EdgeInsets.only(top: 5.0),
    child: new Text(
      description,
      maxLines: 2,
    ),
  );
}

Widget _getDateWidget(String date) {
  return new Text(
    date,
    style: new TextStyle(color: Colors.grey, fontSize: 10.0),
  );
}
