import 'package:task_scape/controllers/meeting_page_controller.dart';
import 'package:task_scape/model/guestProvider.dart';
import 'package:task_scape/views/actions_pages/edit_guests_widgets/guestListEditWidget.dart';
import 'package:task_scape/views/actions_pages/edit_guests_widgets/newGuest.dart';
import 'package:task_scape/views/new_meeting_page/widgets/alertDialogWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditGuests extends StatefulWidget {
  final self;
  final id;
  final tab;

  const EditGuests({Key key, this.self, this.id, this.tab}) : super(key: key);


  @override
  _EditGuestsState createState() => _EditGuestsState();
}

class _EditGuestsState extends State<EditGuests> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Editar Convidados"),
            backgroundColor: Color.fromRGBO(0, 99, 170, 1),
            centerTitle: true,
          ),
          body:  Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text("Convidados Adicionados", style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18.0
                  ),),
                ),
              ),
              Expanded(
                child: Consumer<GuestModel>(
                    builder: (context, conv, child) =>
                        GuestListEdit(conv, widget.id, context, widget.tab)),
              )
            ],
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          NewGuestEdit(
                              self:widget.self,
                              id: widget.id,
                              startDate: MeetingPageController.instance.startDate,
                              endDate: MeetingPageController.instance.endDate
                          )));
            },
            child: Icon(Icons.group_add),
            backgroundColor: Colors.green,
            tooltip: 'Adicionar Convidado',
          ),
        )
    );
  }
  Future<bool> _onBackPressed() {
    return alertDialog(
        context, "Deseja sair da edição de convidados?", backAction) ??
        false;
  }
}

void backAction(BuildContext context) {
  Navigator.of(context).pop(false);
  Navigator.of(context).pop(false);
}
