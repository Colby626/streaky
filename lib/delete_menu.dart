import 'package:flutter/material.dart';
import 'StreakData.dart' as streakData;

class deleteMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Are you sure?"),
      content: Row(
        children: [
          ElevatedButton(
              child: const Text ("Go Back"),
              onPressed: () {
                Navigator.of(context).pop();
              }
          ),
          ElevatedButton(
              child: const Text ("Delete Streak"),
              onPressed: () {
                //Delete the streak from the homepage and reformat
                //streakData.streaks.removeWhere((thisStreak) => thisStreak.name == streakData.streaks[thisStreak].name);
                //WorkManager.getInstance(context).cancelUniqueWork(uniqueWorkName);
                Navigator.of(context).pop();
              }
          )
        ],
      ),
    );
  }
}