//import 'dart:ffi'; causing a build error

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streaky/StreakData.dart';
import 'StreakyEnums.dart';
import 'StreakData.dart' as streakData;
import 'ReadWriteStreak.dart';

TextEditingController nameController = TextEditingController();
TextEditingController monthController = TextEditingController();

class StreakForm extends StatefulWidget {
  const StreakForm(
      this.fieldName,
      {super.key}
      );

  final String fieldName;

  @override
  State<StreakForm> createState() => StreakFormState();
}

class StreakFormState extends State<StreakForm> {
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: widget.fieldName
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}

class StreakPopup extends StatefulWidget{
  const StreakPopup(this.event, {Key? key}) : super(key: key);

  final ValueNotifier<int> event;
  @override
  StreakPopupState createState() => StreakPopupState();
}

class StreakPopupState extends State<StreakPopup>{
  Schedule selectedSchedule = Schedule.Daily;
  Days selectedDay = Days.Monday;
  int dayOfMonth = 0;

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: const Text("Create Streak"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StreakForm("Streak Name"),
          const SizedBox(height: 10),
          DropdownButton(
              value: selectedSchedule,
              icon: const Icon(Icons.arrow_drop_down),
              items: Schedule.values.map((Schedule schedule)
              {
                return DropdownMenuItem(
                    value: schedule,
                    child: Text(schedule.name),
                );
              }).toList(),
              onChanged: (Schedule? newSchedule){
                setState(() {
                  selectedSchedule = newSchedule!;
                });
              }
          ),
          DaysDropdown(selectedSchedule, selectedDay, dayOfMonth)
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
        ElevatedButton(
            onPressed: (){
                setState(() {
                  if (selectedSchedule == Schedule.Weekly) {
                    streakData.streaks.add(StreakData(
                    name: nameController.text,
                    streakCount: 0,
                    schedule: selectedSchedule,
                    days: selectedDay)
                    );
                  }
                  else if (selectedSchedule == Schedule.Monthly){
                    streakData.streaks.add(StreakData(
                      name: nameController.text,
                      streakCount: 0,
                      schedule: selectedSchedule,
                      dayOfMonth: int.parse(monthController.text))
                    );
                  }
                  else{
                    streakData.streaks.add(StreakData(
                        name: nameController.text,
                        streakCount: 0,
                        schedule: selectedSchedule)
                    );
                  }
                WriteStreak(streaks);
                widget.event.value++;
                Navigator.of(context).pop();
              });
            },
            child: const Text("Create")
        )
      ],
    );
  }
}

class StreakButton extends StatelessWidget{
  const StreakButton(
      this.name,
      this.event,
      {Key? key}
      ) : super(key: key);
  final String name;
  final ValueNotifier<int> event;

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        const Padding(padding: EdgeInsets.all(5)),
        SizedBox(
          height: 100,
          width: double.infinity,
          child: ElevatedButton(
            child: Text(name),
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) => StreakPopup(event)
              );}
          ),
        )
      ],
    );
  }
}

class DaysDropdown extends StatefulWidget {
  Days selectedDay;
  Schedule schedule;
  int dayOfMonth;
  DaysDropdown(
      this.schedule,
      this.selectedDay,
      this.dayOfMonth,
      {super.key}
      );

  @override
  State<DaysDropdown> createState() => DaysDropdownState();
}

class DaysDropdownState extends State<DaysDropdown>{
  @override
  void initState() {
    super.initState();
    monthController = TextEditingController();
  }

  @override
  void dispose(){
    super.dispose();
    monthController.dispose();
  }

  @override
  Widget build(BuildContext context){
    if (widget.schedule == Schedule.Weekly)
    {
      return DropdownButton(
          value: widget.selectedDay,
          icon: const Icon(Icons.arrow_drop_down),
          hint: const Text("Starting Day"),
          items: Days.values.map((Days days)
          {
            return DropdownMenuItem(
              value: days,
              child: Text(days.name),
            );
          }).toList(),
          onChanged: (Days? newDay){
            setState(() {
              widget.selectedDay = newDay!;
            });
          }
      );
    }
    else if (widget.schedule == Schedule.Monthly)
      {
        return TextFormField(
          autovalidateMode: AutovalidateMode.always,
          decoration: const InputDecoration(
            icon: Icon(Icons.calendar_month),
            hintText: "What day of the month?",
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
          controller: monthController,
          validator: (value){
            if (value == null || value.isEmpty || int.parse(value) > 31 || int.parse(value) < 1){
              return 'Enter Day 1-31';
            }
            return null;
          },
        );
      }
    else {
      return const SizedBox.shrink();
    }
  }
}