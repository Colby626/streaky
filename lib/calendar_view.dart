import 'package:flutter/material.dart';
import 'package:streaky/StreakyEnums.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'StreakData.dart' as streakData;

class CalendarView extends StatelessWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Calendar View',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Calendar View"),
          ),
          body: SafeArea (
            minimum: const EdgeInsets.all(15),
            child: SfCalendar(
              dataSource: _getCalendarDataSource(),
          ),
        ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.blue,
            child: Row(
                children: [
                  IconButton(
                    color: Colors.white,
                    tooltip: "Back",
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ]
            ),
          ),
        )
    );
  }
}

_AppointmentDataSource _getCalendarDataSource() {
  List<Appointment> appointments = <Appointment>[];
  for (int i = 0; i < streakData.streaks.length; i++)
    {
      appointments.add(Appointment(
        startTime: DateTime(2023, 4, 19),
        endTime: DateTime(2023, 4, 19),
        subject: streakData.streaks[i].name,
        color: Colors.blue,
        startTimeZone: '',
        endTimeZone: '',
        isAllDay: true,
        recurrenceRule: RecurranceString(streakData.streaks[i].schedule),
      ));
    }
  /*
  appointments.add(Appointment(
    startTime: DateTime(2023, 4, 19),
    endTime: DateTime(2023, 4, 19),
    subject: 'Meeting',
    color: Colors.blue,
    startTimeZone: '',
    endTimeZone: '',
    isAllDay: true,
    recurrenceRule: 'FREQ=DAILY;INTERVAL=2;COUNT=10',
  ));
  */
  return _AppointmentDataSource(appointments);
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source){
    appointments = source;
  }
}

String RecurranceString(Schedule schedule)
{
  String string = "";

  switch (schedule)
  {
    case Schedule.Daily:
      {
        string = "FREQ=DAILY;";
      }
      break;

    case Schedule.Weekly:
      {
        string = "FREQ=WEEKLY;";
      }
      break;

    case Schedule.Monthly:
      {
        string = "FREQ=MONTHLY;";
      }
      break;

    case Schedule.Yearly:
      {
        string = "FREQ=YEARLY;";
      }
      break;

    case Schedule.BiWeekly:
      {
        string = "FREQ=WEEKLY;INTERVAL=2;";
      }
      break;

    case Schedule.MWF:
      {
        string = "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,WE,FR";
      }
      break;

    case Schedule.TR:
      {
        string = "FREQ=MONTHLY;INTERVAL=1;BYDAY=TU,TH";
      }
      break;
  }

  return string;
}
