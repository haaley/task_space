import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final f = new DateFormat('dd/MM/yyyy HH:mm');

Widget getColumText(String title, date, description, author,status) {
  return new Expanded(
      child: new Container(
        margin: new EdgeInsets.all(10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _getTitleWidget(title),
            _getDateWidget(date),
            new Divider(
              color: Colors.blueGrey,
            ),
            _getDescriptionWidget(description),
            new Divider(
              color: Colors.blueGrey,
            ),
            _getAutorWidget('Autor: ${author}'),
            new Divider(
              color: Colors.blueGrey,
            ),
            _getStatusWidget(status),
          ],
        ),
      ));
}

Widget _getStatusWidget(String status) {
  return Container(
      padding: new EdgeInsetsDirectional.only(top: 10),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                  status == "FINISHED"
                      ? "Status: Finalizada"
                      : "Status: Agendada",
                  style: new TextStyle(color: Colors.black, fontSize: 15.0)),
            ],
          ),
        ],
      ));
}

Widget _getAutorWidget(String autor) {
  return Container(
      padding: new EdgeInsetsDirectional.only(top: 10),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(autor,
                  style: new TextStyle(color: Colors.black, fontSize: 15.0)),
            ],
          ),
        ],
      ));
}

Widget _getTitleWidget(String curencyName) {
  return Row(children: <Widget>[
    new Flexible(
      child: Text(
        curencyName,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: new TextStyle(
            fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    )
  ]);
}

Widget _getDescriptionWidget(String description) {
  return new Container(
      margin: new EdgeInsets.only(top: 7.0),
      child: Text(
        description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: new TextStyle(fontSize: 15.0, color: Colors.black),
      ));
}

Widget _getDateWidget(String date) {
  return Row(
    children: <Widget>[
      Text(
        'Data: ',
        style: new TextStyle(color: Colors.black, fontSize: 15.0),
      ),
      new Text(
        f.format(DateTime.parse(date)),
        style: new TextStyle(color: Colors.black, fontSize: 15.0),
      ),
    ],
  );
}