import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:streaky/StreakData.dart';
import 'StreakyEnums.dart';
import 'StreakData.dart' as streakData;
import 'ReadWriteStreak.dart';

final TextEditingController controller = TextEditingController();


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
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: widget.fieldName
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
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
  Schedule startingValue = Schedule.Daily;

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
              value: startingValue,
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
                  startingValue = newSchedule!;
                });
              }
          )
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(controller.text),
                    );
                  }
              );
            },
            icon: const Icon(Icons.access_alarm)),
        ElevatedButton(
            onPressed: (){
              //Create Streak on home screen
              setState(() {
                streakData.streaks.add(StreakData(controller.text, 0, Schedule.Daily));
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