import 'package:task_scape/controllers/meeting_page_controller.dart';
import 'package:task_scape/model/guestProvider.dart';
import 'package:flutter/material.dart';

Widget GuestListWidget(GuestModel guest, int index) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: new BorderRadius.circular(40.0), color: Colors.white),
    width: 300,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Flexible(
            child: Image(
              image: AssetImage("assets/avatar.png"),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(3.0),
          child: Center(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 3.0),
                    child: ValueListenableBuilder(
                      valueListenable: MeetingPageController.instance.status,
                      builder: (context, value, child) {
                        print("status : ${value[index]}");
                        return Icon(value[index] == "AUTHOR" ? Icons.edit: Icons.person, size:12.0);
                      },
                    ),
                  ),
                  Expanded(
                    child: Text(guest.guestList[index].name, softWrap: false,
                      overflow: TextOverflow.ellipsis,),
                  ),
                ],
              )
          ),
        ),
        Container(
            child:Padding(
              padding: EdgeInsets.all(3.0),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 3.0),
                    child: Icon(
                      guest.guestList[index].conflict ? Icons.cancel : Icons.check_circle,
                      color: guest.guestList[index].conflict ? Colors.red: Colors.green,
                      size: 12,
                    ),
                  ),
                  Expanded(
                      child: Text(
                        guest.guestList[index].email,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ))
                ],
              ),
            )
        )
      ],
    ),
  );
}