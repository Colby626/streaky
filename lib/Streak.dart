import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:streaky/ReadWriteStreak.dart';
import 'package:workmanager/workmanager.dart';
import 'StreakData.dart' as streakData;
import 'dart:developer' as developer;

class Streak extends StatefulWidget{
  Streak(
      this.name,
      this.streakCount,
      this.streakIcon,
      this.frequency,
      {Key? key}
      ) : super(key: key);

  final String name;
  int streakCount;
  final IconData streakIcon;
  final String frequency;
  final event = ValueNotifier(0);
  @override
  StreakState createState() => StreakState();
}

class StreakState extends State<Streak>{
  @override
  void initState() {
    super.initState();
    FetchStreaks();
  }

  void FetchStreaks() async {
    setState(() {
      ReadStreaks("streaks");
      widget.event.value++;
      developer.log("Streak ${streakData.streaks[0].streakCount}");
    });
  }

  @override
  Widget build(BuildContext context){
    return SizedBox(
        height: 100,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            for (int i = 0; i < streakData.streaks.length; i++)
            {
              if (streakData.streaks[i].name == widget.name)
              {
                switch (widget.frequency)
                {
                  case 'Daily':
                    {
                      if (DateTime.now().difference(streakData.streaks[i].lastButtonPress).inSeconds > const Duration(seconds: 5).inSeconds)
                      {
                        //streakCount++;
                        streakData.streaks[i].streakCount++;
                        streakData.streaks[i].lastButtonPress = DateTime.now();
                        streakData.streaks[i].streakDone = true;
                        WriteStreak("streaks");
                        Workmanager().registerOneOffTask(widget.name,widget.name, initialDelay: const Duration(seconds: 5));
                        widget.event.value++;
                      }
                      break;
                    }
                  case 'Weekly':
                    {
                      if (DateTime.now().difference(streakData.streaks[i].lastButtonPress).inDays > const Duration(days: 7).inDays)
                      {
                        //streakCount++;
                        streakData.streaks[i].streakCount++;
                        streakData.streaks[i].lastButtonPress = DateTime.now();
                        streakData.streaks[i].streakDone = true;
                        WriteStreak("streaks");
                        widget.event.value++;
                      }
                      break;
                    }
                  case 'Monthly':
                    {
                      if (DateTime.now().difference(streakData.streaks[i].lastButtonPress).inDays > const Duration(days: 31).inDays)
                      {
                        //streakCount++;
                        streakData.streaks[i].streakCount++;
                        streakData.streaks[i].lastButtonPress = DateTime.now();
                        streakData.streaks[i].streakDone = true;
                        WriteStreak("streaks");
                        widget.event.value++;
                      }
                      break;
                    }
                  case 'Yearly':
                    {
                      if (DateTime.now().difference(streakData.streaks[i].lastButtonPress).inDays > const Duration(days: 365).inDays)
                      {
                        //streakCount++;
                        streakData.streaks[i].streakCount++;
                        streakData.streaks[i].lastButtonPress = DateTime.now();
                        streakData.streaks[i].streakDone = true;
                        WriteStreak("streaks");
                        widget.event.value++;
                      }
                      break;
                    }
                }
                break;
              }
            }
          },
          onLongPress: () => showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text("Delete Streak?"),
                content: const Text("Once a Streak has been deleted it will be removed from your calendar and can never be recovered"),
                actions: [
                  TextButton(
                    child: const Text("Confirm"),
                    onPressed: (){
                      streakData.streaks.removeWhere((element) => element.name == widget.name);
                      WriteStreak("streaks");
                      Workmanager().cancelByUniqueName(widget.name);
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel")
                  )
                ],
              )
          ),
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(widget.streakIcon, size: 50,),
              ),
              const SizedBox(width: 30),
              Align(
                alignment: Alignment.center,
                child: ValueListenableBuilder<int>(
                    valueListenable: widget.event,
                    builder: (BuildContext context, int value,
                        Widget? child) {
                      return Text(streakData.streaks.singleWhere((element) => element.name == widget.name).streakCount.toString(), style: const TextStyle(color: Colors.amber, fontSize: 34));
                    }
                ),
                //child: Text(streakCount.toString(), style: const TextStyle(color: Colors.amber, fontSize: 34)),
              ),
              const SizedBox(width: 30,),
              Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: AutoSizeText(
                      widget.name,
                      style: const TextStyle(color: Colors.amber, fontSize: 34),
                      maxLines: 3,
                      textDirection: TextDirection.rtl,
                    ),
                  )//Text(name, style: const TextStyle(color: Colors.amber, fontSize: 34))
              ),
              const SizedBox(width: 30),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(widget.frequency, style: const TextStyle(color: Colors.amber, fontSize: 34))
              )
            ],
          ),
        )
    );
  }
}