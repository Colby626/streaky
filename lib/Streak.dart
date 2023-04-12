import 'package:flutter/material.dart';

class Streak extends StatelessWidget{
  const Streak(
      this.name,
      this.streakCount,
      this.streakIcon,
      {Key? key}
      ) : super(key: key);

  final String name;
  final int streakCount;
  final IconData streakIcon;

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Card(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(streakIcon, size: 50,),
              ),
              const SizedBox(width: 30),
              Align(
                alignment: Alignment.center,
                child: Text(streakCount.toString(), style: const TextStyle(color: Colors.amber, fontSize: 34)),
              ),
              const SizedBox(width: 30,),
              Align(
               alignment: Alignment.center,
               child: Text(name, style: const TextStyle(color: Colors.amber, fontSize: 34))
              )
            ],
          ),
        )
      )
    );
  }
}