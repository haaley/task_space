import 'package:task_scape/controllers/new_meeting_page_controller.dart';
import 'package:task_scape/views/new_meeting_page/widgets/DatePickerWidget.dart';
import 'package:flutter/material.dart';


Step stepInfo(){
  return Step(
    title: const Text("Detalhes"),
    isActive: true,
    state: NewMeetingPageController.instance.currentState.value == 0
        ? StepState.editing
        : NewMeetingPageController.instance.currentState.value > 0 ? StepState.complete : StepState.disabled,
    content: Form(
      key: NewMeetingPageController.instance.formkey,
      child:  Column(children: <Widget>[
        ListTile(
          leading: Icon(Icons.title),
          title: TextFormField(
            validator: (value) {
              if (value.isEmpty || value.length < 1) {
                return 'Coloque um título.';
              }
              else{
                return null;
              }
            },
            textCapitalization: TextCapitalization.sentences,
            maxLength: 100,
            maxLengthEnforced: true,
            controller: NewMeetingPageController.instance.titleController,
            onSaved: (value) {
              NewMeetingPageController.instance.saveInfo(value, NewMeetingPageController.instance.identifyTitle);

            },
            decoration: InputDecoration(
              hintText: "Título",
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: TextFormField(
            validator: (value) {
              if (value.isEmpty || value.length < 1) {
                return 'Coloque um local.';
              }
              else{
                return null;
              }
            },
            maxLength: 50,
            maxLengthEnforced: true,
            textCapitalization: TextCapitalization.sentences,
            controller: NewMeetingPageController.instance.localController,
            onSaved: (value) {
              NewMeetingPageController.instance.saveInfo(value, NewMeetingPageController.instance.identifyLocal);

            },
            decoration: InputDecoration(
              hintText: "Local",
            ),
          ),
        ),
        ListTile(
          leading: new Icon(Icons.date_range),
          title: DatePick(NewMeetingPageController.instance.identifyStartDate),
        ),
        ListTile(
          leading: new Icon(Icons.calendar_today),
          title: DatePick(NewMeetingPageController.instance.identifyEndDate),
        ),
        ListTile(
          leading: Icon(Icons.dehaze),
          title: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            maxLength: 500,
            maxLengthEnforced: true,
            validator: (value) {
              if (value.isEmpty || value.length < 1) {
                return 'Insira uma descrição.';
              }
              else{
                return null;
              }
            },
            textCapitalization: TextCapitalization.sentences,
            onSaved: (value) {
              NewMeetingPageController.instance.saveInfo(value, NewMeetingPageController.instance.identifyDescription);
            },
            controller: NewMeetingPageController.instance.descriptionController,
            decoration: InputDecoration(
              hintText: "Descrição da reunião.",
            ),
          ),
        ),
      ]),
    )
  );
}
