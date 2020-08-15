import 'package:task_scape/controllers/new_meeting_page_controller.dart';
import 'package:task_scape/views/new_meeting_page/widgets/addGuestWidgets/addGuestListWidget.dart';
import 'package:flutter/material.dart';


Step stepGuest(){
  return Step(
    title: const Text("Convidados"),
    isActive: true,
    state: NewMeetingPageController.instance.currentState.value == 1
        ? StepState.editing
        : NewMeetingPageController.instance.currentState.value > 1 ? StepState.complete : StepState.disabled,
    content: AddGuestList()
  );
}
