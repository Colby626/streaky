import 'package:flutter/material.dart';

class Streak extends StatelessWidget{
  Streak(
      this.name,
      this.streakCount,
      this.streakIcon,
      {Key? key}
      ) : super(key: key);

  final String name;
  int streakCount;
  final IconData streakIcon;
  final event = ValueNotifier(0);

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (){streakCount++; event.value++;},
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
            )
          ],
        ),
      )
  );
  }
}