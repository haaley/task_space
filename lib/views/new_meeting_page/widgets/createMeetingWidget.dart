import 'package:task_scape/controllers/new_meeting_page_controller.dart';
import 'package:task_scape/views/new_meeting_page/widgets/stepGuestsWidget.dart';
import 'package:task_scape/views/new_meeting_page/widgets/stepInfoWidget.dart';
import 'package:task_scape/views/new_meeting_page/widgets/stepMeetingAgenda.dart';
import 'package:flutter/material.dart';

class CreateMeetingStepper extends StatefulWidget {
  @override
  _CreateMeetingStepperState createState() => _CreateMeetingStepperState();
}

class _CreateMeetingStepperState extends State<CreateMeetingStepper> {
  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      stepInfo(),
      stepGuest(),
      stepMeetingAgenda()
    ];
    return Form(
      child: Stepper(
        steps: steps,
        type: StepperType.horizontal,
        controlsBuilder: (BuildContext context,
            {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
          return Container(
            color: Colors.white,
          );
        },
        currentStep: NewMeetingPageController.instance.currentState.value,
      ),
    );
  }
}
