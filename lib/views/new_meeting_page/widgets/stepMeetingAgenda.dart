import 'package:task_scape/controllers/new_meeting_page_controller.dart';
import 'package:task_scape/views/new_meeting_page/widgets/addMeetingAgendaWidget.dart';
import 'package:flutter/material.dart';


Step stepMeetingAgenda(){
  return Step(
        title: const Text("Pautas"),
      isActive: true,
      state: NewMeetingPageController.instance.currentState.value == 2
          ? StepState.editing
          : NewMeetingPageController.instance.currentState.value > 2  ? StepState.complete : StepState.disabled,
      content: NewMeetingAgenda()
  );
}
