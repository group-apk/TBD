import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mynda/model/appointment_model.dart';
import 'package:mynda/provider/appointment_provider.dart';
import 'package:mynda/provider/user_provider.dart';
import 'package:mynda/services/api.dart';
import 'package:mynda/view/appointment/add_guest_appointment.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime _selectedCalendarDate = DateTime.now();
  DateTime _focusedCalendarDate = DateTime.now();

  late Map<DateTime, List<AppointmentModel>> mySelectedEvents;

  @override
  void initState() {
    _selectedCalendarDate = _focusedCalendarDate;
    mySelectedEvents = {
      DateTime(2022, 6, 16): [
        AppointmentModel(
          description: ['wuu'],
        )
      ],
    };
    super.initState();
  }

  List<AppointmentModel> _listOfDayEvents(DateTime dateTime) {
    return mySelectedEvents[dateTime] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    // final navigator = Navigator.of(context);
    final appointmentProvider = context.read<AppointmentProvider>();
    final userProvider = context.read<UserProvider>();

    Widget body = Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.blue[50],
              margin: const EdgeInsets.symmetric(horizontal: 15),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        color: Colors.blue,
                        margin: const EdgeInsets.only(bottom: 5),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            'APPOINTMENTS',
                            textScaleFactor: 2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.robotoCondensed(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        margin: EdgeInsets.zero,
                        color: Colors.blue,
                        child: Card(
                          // margin: const EdgeInsets.all(5),
                          child: TableCalendar(
                            firstDay: DateTime.utc(2010, 10, 16),
                            lastDay: DateTime.utc(2030, 3, 14),
                            focusedDay: _focusedCalendarDate,
                            headerStyle: HeaderStyle(
                              titleTextStyle: GoogleFonts.robotoCondensed(),
                              formatButtonTextStyle: GoogleFonts.robotoCondensed(),
                            ),
                            calendarStyle: CalendarStyle(
                              defaultTextStyle: GoogleFonts.robotoCondensed(),
                              todayTextStyle: GoogleFonts.robotoCondensed(color: Colors.white),
                              holidayTextStyle: GoogleFonts.robotoCondensed(),
                              outsideTextStyle: GoogleFonts.robotoCondensed(),
                              weekendTextStyle: GoogleFonts.robotoCondensed(),
                              disabledTextStyle: GoogleFonts.robotoCondensed(),
                              selectedTextStyle: GoogleFonts.robotoCondensed(),
                            ),
                            calendarFormat: CalendarFormat.week,
                            selectedDayPredicate: (currentSelectedDate) {
                              // as per the documentation 'selectedDayPredicate' needs to determine current selected day.
                              return (isSameDay(_selectedCalendarDate, currentSelectedDate));
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              // as per the documentation
                              if (!isSameDay(_selectedCalendarDate, selectedDay)) {
                                setState(() {
                                  _selectedCalendarDate = selectedDay;
                                  _focusedCalendarDate = focusedDay;
                                });
                              }
                            },
                            eventLoader: _listOfDayEvents,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: _listOfDayEvents(_selectedCalendarDate)
                          .map(
                            (myEvents) => ListTile(
                              leading: const Icon(
                                Icons.done,
                              ),
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text('Event Title:   ${myEvents.category![0]}'),
                              ),
                              subtitle: Text('Description:   ${myEvents.description![0]}'),
                            ),
                          )
                          .toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10.0, top: 10),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: MaterialButton(
                                  highlightElevation: 0,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  onPressed: () {
                                    getAppointments(userProvider, appointmentProvider);
                                    showDialog(context: context, builder: (context) => const AddGuestScreen());
                                  },
                                  child: Text(
                                    'NEW GUEST APPOINTMENT',
                                    style: GoogleFonts.robotoCondensed(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: MaterialButton(
                                  highlightElevation: 0,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  onPressed: () {
                                    getGuests(userProvider, appointmentProvider);
                                    showDialog(context: context, builder: (context) => const AddGuestScreen());
                                  },
                                  child: Text(
                                    'VIEW GUESTS',
                                    style: GoogleFonts.robotoCondensed(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return body;
  }
}
