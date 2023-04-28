import 'package:flutter/material.dart';
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
                  if (!streakData.streaks[i].streakDone) //streakCount hasn't been increased in its scheduled period already
                      {
                    streakCount++;
                    event.value++;
                    streakData.streaks[i].streakCount++;
                    streakData.streaks[i].streakDone = true;
                    break;
                  }
                }
            }
        },
        //onLongPress: deleteMenu,
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
                child: Text(name, style: const TextStyle(color: Colors.amber, fontSize: 34))
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