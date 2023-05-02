import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:streaky/ReadWriteStreak.dart';
import 'package:workmanager/workmanager.dart';
import 'StreakData.dart' as streakData;

class Streak extends StatelessWidget{
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
  final event = ValueNotifier(0);
  final String frequency;

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          for (int i = 0; i < streakData.streaks.length; i++)
            {
              if (streakData.streaks[i].name == name)
                {
                  switch (frequency)
                  {
                    case 'Daily':
                      {
                        if (DateTime.now().difference(streakData.streaks[i].lastButtonPress).inSeconds > const Duration(seconds: 5).inSeconds)
                        {
                          streakCount++;
                          streakData.streaks[i].streakCount++;
                          streakData.streaks[i].lastButtonPress = DateTime.now();
                          streakData.streaks[i].streakDone = true;
                          WriteStreak("streaks");
                          Workmanager().registerOneOffTask(name,name, initialDelay: const Duration(seconds: 5));
                          event.value++;
                        }
                        break;
                      }
                    case 'Weekly':
                      {
                        if (DateTime.now().difference(streakData.streaks[i].lastButtonPress).inDays > const Duration(days: 7).inDays)
                        {
                          streakCount++;
                          streakData.streaks[i].streakCount++;
                          streakData.streaks[i].lastButtonPress = DateTime.now();
                          streakData.streaks[i].streakDone = true;
                          WriteStreak("streaks");
                          event.value++;
                        }
                        break;
                      }
                    case 'Monthly':
                      {
                        if (DateTime.now().difference(streakData.streaks[i].lastButtonPress).inDays > const Duration(days: 31).inDays)
                        {
                          streakCount++;
                          streakData.streaks[i].streakCount++;
                          streakData.streaks[i].lastButtonPress = DateTime.now();
                          streakData.streaks[i].streakDone = true;
                          WriteStreak("streaks");
                          event.value++;
                        }
                        break;
                      }
                    case 'Yearly':
                      {
                        if (DateTime.now().difference(streakData.streaks[i].lastButtonPress).inDays > const Duration(days: 365).inDays)
                        {
                          streakCount++;
                          streakData.streaks[i].streakCount++;
                          streakData.streaks[i].lastButtonPress = DateTime.now();
                          streakData.streaks[i].streakDone = true;
                          WriteStreak("streaks");
                          event.value++;
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
                    streakData.streaks.removeWhere((element) => element.name == name);
                    WriteStreak("streaks");
                    Workmanager().cancelByUniqueName(name);
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
              child: Icon(streakIcon, size: 50,),
            ),
            const SizedBox(width: 30),
            Align(
              alignment: Alignment.center,
              child: ValueListenableBuilder<int>(
                valueListenable: event,
                builder: (BuildContext context, int value,
                Widget? child) {
                    return Text(streakCount.toString(), style: const TextStyle(color: Colors.amber, fontSize: 34));
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
                    name,
                    style: const TextStyle(color: Colors.amber, fontSize: 34),
                    maxLines: 3,
                    textDirection: TextDirection.rtl,
                  ),
                )//Text(name, style: const TextStyle(color: Colors.amber, fontSize: 34))
            ),
            const SizedBox(width: 30),
              Align(
                alignment: Alignment.centerRight,
                child: Text(frequency, style: const TextStyle(color: Colors.amber, fontSize: 34))
              )
          ],
        ),
      )
  );
  }
}