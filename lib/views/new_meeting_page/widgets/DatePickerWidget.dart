import 'package:task_scape/controllers/new_meeting_page_controller.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePick extends StatelessWidget {
  final idDate;

  DatePick(
      this.idDate
      );

  final format = DateFormat("dd-MM-yyyy HH:mm.sss");
  final newformat = DateFormat("dd-MM-yyyy HH:mm.sss");

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();

    return Column(
      children: [
        DateTimeField(
          format: format,
          initialValue: this.idDate == NewMeetingPageController.instance.identifyStartDate ? NewMeetingPageController.instance.startDate : NewMeetingPageController.instance.endDate,
          onShowPicker: (context,currentValue) async{
            final date = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100));

            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime:
                TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          },
          controller: this.idDate == NewMeetingPageController.instance.identifyStartDate ? NewMeetingPageController.instance.startdateController: NewMeetingPageController.instance.enddateController,
          decoration: new InputDecoration(
            hintText: "Insira uma data e hora.",
          ),
          onSaved: (value){
            NewMeetingPageController.instance.convertData(value.toString(), this.idDate);
          },
          onChanged: (v){
            NewMeetingPageController.instance.onChagedDate(this.idDate, v);
          },
          validator: (value){
            int answ =  NewMeetingPageController.instance.validate(this.idDate, value);

            if(answ == 0){
              print("nulo");
              return "Insira uma Data válida.";
            }
            else if(answ == 2){
              return "Insira um intervalo válido.";
            }
            else{
              return null;
            }
          },
        )
      ],
    );
  }
}
