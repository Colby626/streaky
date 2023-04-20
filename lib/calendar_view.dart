import 'package:flutter/material.dart';
import 'package:streaky/StreakyEnums.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'StreakData.dart' as streakData;

class CalendarView extends StatelessWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Streaky",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Calendar View"),
            automaticallyImplyLeading: true,
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
                    onPressed: () => Navigator.pop(context),
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
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        subject: streakData.streaks[i].name,
        color: Colors.blue,
        startTimeZone: '',
        endTimeZone: '',
        isAllDay: true,
      ));
      appointments[i].recurrenceRule = SfCalendar.generateRRule(RecurranceData(streakData.streaks[i].schedule), DateTime.now(), DateTime.now());
    }
  return _AppointmentDataSource(appointments);
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source){
    appointments = source;
  }
}

RecurrenceProperties RecurranceData(Schedule schedule) //Will need Days day and DayOfMonth dayOfMonth and Month month
{
  RecurrenceProperties properties;

  switch (schedule)
  {
    case Schedule.Daily:
      {
        properties = RecurrenceProperties(
          startDate: DateTime.now(),
          recurrenceType: RecurrenceType.daily,
          recurrenceRange: RecurrenceRange.noEndDate,
        );
      }
      break;

    case Schedule.Weekly: //currently doing daily since weekly doesn't work without a specific day in mind
      {
        /*
        switch (Days.days)

          case Days.Monday:
          {
            properties = RecurrenceProperties(
            startDate: DateTime.now(),
            recurrenceType: RecurrenceType.weekly,
            weekDays: <WeekDays>[WeekDays.monday],
            recurrenceRange: RecurrenceRange.noEndDate,
          }
          break;

          case Days.Tuesday:
          {
            properties = RecurrenceProperties(
            startDate: DateTime.now(),
            recurrenceType: RecurrenceType.weekly,
            weekDays: <WeekDays>[WeekDays.tuesday],
            recurrenceRange: RecurrenceRange.noEndDate,
          }
          break;

          case Days.Wednesday:
          {
            properties = RecurrenceProperties(
            startDate: DateTime.now(),
            recurrenceType: RecurrenceType.weekly,
            weekDays: <WeekDays>[WeekDays.wednesday],
            recurrenceRange: RecurrenceRange.noEndDate,
          }
          break;

          case Days.Thursday:
          {
            properties = RecurrenceProperties(
            startDate: DateTime.now(),
            recurrenceType: RecurrenceType.weekly,
            weekDays: <WeekDays>[WeekDays.thursday],
            recurrenceRange: RecurrenceRange.noEndDate,
          }
          break;

          case Days.Friday:
          {
            properties = RecurrenceProperties(
            startDate: DateTime.now(),
            recurrenceType: RecurrenceType.weekly,
            weekDays: <WeekDays>[WeekDays.friday],
            recurrenceRange: RecurrenceRange.noEndDate,
          }
          break;

          case Days.Saturday:
          {
            properties = RecurrenceProperties(
            startDate: DateTime.now(),
            recurrenceType: RecurrenceType.weekly,
            weekDays: <WeekDays>[WeekDays.saturday],
            recurrenceRange: RecurrenceRange.noEndDate,
          }
          break;

          case Days.Sunday:
          {
            properties = RecurrenceProperties(
            startDate: DateTime.now(),
            recurrenceType: RecurrenceType.weekly,
            weekDays: <WeekDays>[WeekDays.sunday],
            recurrenceRange: RecurrenceRange.noEndDate,
          }
          break;
         */
        //Whats between this comment and break will be removed when Days enum is factored into streak creation
        properties = RecurrenceProperties(
          startDate: DateTime.now(),
          recurrenceType: RecurrenceType.daily,
          recurrenceRange: RecurrenceRange.noEndDate,
        );
      }
      break;

    case Schedule.WeeklyOnMonday:
      {
        properties = RecurrenceProperties(
          startDate: DateTime.now(),
          interval: 1,
          weekDays: <WeekDays>[WeekDays.monday],
          recurrenceType: RecurrenceType.weekly,
          recurrenceRange: RecurrenceRange.noEndDate,
        );
      }
      break;

    case Schedule.WeeklyOnTuesday:
      {
        properties = RecurrenceProperties(
          startDate: DateTime.now(),
          interval: 1,
          weekDays: <WeekDays>[WeekDays.tuesday],
          recurrenceType: RecurrenceType.weekly,
          recurrenceRange: RecurrenceRange.noEndDate,
        );
      }
      break;

    case Schedule.Monthly:
      {
        /*
        properties = RecurrenceProperties(
          startDate: DateTime.now(),
          dayOfMonth = dayOfMonth,
          recurrenceType: RecurrenceType.monthly,
          recurrenceRange: RecurrenceRange.noEndDate,
        );
         */
        properties = RecurrenceProperties(
          startDate: DateTime.now(),
          recurrenceType: RecurrenceType.monthly,
          recurrenceRange: RecurrenceRange.noEndDate,
        );
      }
      break;

    case Schedule.Yearly:
      {
        /*
        properties = RecurrenceProperties(
          startDate: DateTime.now(),
          dayOfMonth = dayOfMonth,
          month = month,
          recurrenceType: RecurrenceType.monthly,
          recurrenceRange: RecurrenceRange.noEndDate,
        );
         */
        properties = RecurrenceProperties(
          startDate: DateTime.now(),
          recurrenceType: RecurrenceType.yearly,
          recurrenceRange: RecurrenceRange.noEndDate,
        );
      }
      break;

    case Schedule.BiWeekly:
      {
        /*
        switch (Days.days)

          case Days.Monday:
          {
            properties = RecurrenceProperties(
            startDate: DateTime.now(),
            recurrenceType: RecurrenceType.weekly,
            weekDays: <WeekDays>[WeekDays.monday],
            recurrenceRange: RecurrenceRange.noEndDate,
          }
          break;

          case Days.Tuesday:
          {
            properties = RecurrenceProperties(
            startDate: DateTime.now(),
            recurrenceType: RecurrenceType.weekly,
            weekDays: <WeekDays>[WeekDays.tuesday],
            recurrenceRange: RecurrenceRange.noEndDate,
          }
          break;

          case Days.Wednesday:
          {
            properties = RecurrenceProperties(
            startDate: DateTime.now(),
            recurrenceType: RecurrenceType.weekly,
            weekDays: <WeekDays>[WeekDays.wednesday],
            recurrenceRange: RecurrenceRange.noEndDate,
          }
          break;

          case Days.Thursday:
          {
            properties = RecurrenceProperties(
            startDate: DateTime.now(),
            recurrenceType: RecurrenceType.weekly,
            weekDays: <WeekDays>[WeekDays.thursday],
            recurrenceRange: RecurrenceRange.noEndDate,
          }
          break;

          case Days.Friday:
          {
            properties = RecurrenceProperties(
            startDate: DateTime.now(),
            recurrenceType: RecurrenceType.weekly,
            weekDays: <WeekDays>[WeekDays.friday],
            recurrenceRange: RecurrenceRange.noEndDate,
          }
          break;

          case Days.Saturday:
          {
            properties = RecurrenceProperties(
            startDate: DateTime.now(),
            recurrenceType: RecurrenceType.weekly,
            weekDays: <WeekDays>[WeekDays.saturday],
            recurrenceRange: RecurrenceRange.noEndDate,
          }
          break;

          case Days.Sunday:
          {
            properties = RecurrenceProperties(
            startDate: DateTime.now(),
            recurrenceType: RecurrenceType.weekly,
            weekDays: <WeekDays>[WeekDays.sunday],
            recurrenceRange: RecurrenceRange.noEndDate,
          }
          break;
         */
        //Below will be removed when Days are factored into streak creation
        properties = RecurrenceProperties(
          startDate: DateTime.now(),
          recurrenceType: RecurrenceType.weekly,
          interval: 2,
          recurrenceRange: RecurrenceRange.noEndDate,
        );
      }
      break;

    case Schedule.MWF:
      {
        properties = RecurrenceProperties(
          startDate: DateTime.now(),
          recurrenceType: RecurrenceType.weekly,
          weekDays: <WeekDays>[WeekDays.monday, WeekDays.wednesday, WeekDays.friday],
        );
      }
      break;

    case Schedule.TR:
      {
        properties = RecurrenceProperties(
          startDate: DateTime.now(),
          recurrenceType: RecurrenceType.weekly,
          weekDays: <WeekDays>[WeekDays.tuesday, WeekDays.thursday],
        );
      }
      break;
  }

  return properties;
}
