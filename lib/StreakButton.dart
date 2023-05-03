import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streaky/StreakData.dart';
import 'package:workmanager/workmanager.dart';
import 'StreakyEnums.dart';
import 'StreakData.dart' as streakData;
import 'ReadWriteStreak.dart';

TextEditingController nameController = TextEditingController();
TextEditingController monthController = TextEditingController(); //Actually controls the days of a month
TextEditingController yearController = TextEditingController(); //Actually controls the months

Days selectedDay = Days.Monday;

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
  int dayOfMonth = 0;
  int month = 0;

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
          DaysDropdown(selectedSchedule, dayOfMonth, month)
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
                  else if (selectedSchedule == Schedule.Yearly){
                    streakData.streaks.add(StreakData(
                      name : nameController.text,
                      streakCount: 0,
                      schedule: selectedSchedule,
                      dayOfMonth: int.parse(monthController.text),
                      month: int.parse(yearController.text)
                    ));
                  }
                  else{
                    streakData.streaks.add(StreakData(
                        name: nameController.text,
                        streakCount: 0,
                        schedule: selectedSchedule)
                    );
                  }
                WriteStreak("streaks");
                switch(selectedSchedule) //Workmanager periodic tasks will run in the background even if the app is closed, ours send a notification
                {
                  case Schedule.Daily:
                    {
                      Workmanager().registerPeriodicTask(nameController.text, nameController.text, initialDelay: const Duration (days: 1));
                    }
                    break;
                  case Schedule.Weekly:
                    {
                      Workmanager().registerPeriodicTask(nameController.text, nameController.text, frequency: const Duration(days: 7));
                    }
                    break;
                  case Schedule.Monthly:
                    {
                      Workmanager().registerPeriodicTask(nameController.text, nameController.text, frequency: const Duration(days: 31)); //doesn't account for different length months
                    }
                    break;
                  case Schedule.Yearly:
                    {
                      Workmanager().registerPeriodicTask(nameController.text, nameController.text, frequency: const Duration(days: 365)); //doesn't account for leap years
                    }
                    break;
                }
                Navigator.of(context).pop();
              });
            },
            child: const Text("Create")
        ),
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
            child: Text(name, style: const TextStyle(fontSize: 24),),
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
  Schedule schedule;
  int dayOfMonth;
  int month;
  DaysDropdown(
      this.schedule,
      this.dayOfMonth,
      this.month,
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
    yearController = TextEditingController();
  }

  @override
  void dispose(){
    super.dispose();
    monthController.dispose();
    yearController.dispose();
  }

  @override
  Widget build(BuildContext context){
    if (widget.schedule == Schedule.Weekly)
    {
      return DropdownButton(
          value: selectedDay,
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
              selectedDay = newDay!;
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
    else if (widget.schedule == Schedule.Yearly)
    {
      return Column(
      children:[
        TextFormField(
          autovalidateMode: AutovalidateMode.always,
          decoration: const InputDecoration(
            icon: Icon(Icons.calendar_month),
            hintText: "What month?",
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
          controller: yearController,
          validator: (value){
            if (value == null || value.isEmpty || int.parse(value) > 12 || int.parse(value) < 1){
              return 'Enter Month 1-12';
            }
            return null;
          },
        ),
        TextFormField(
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
        )
      ]
      );
    }
    else {
      return const SizedBox.shrink();
    }
  }
}