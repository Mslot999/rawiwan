import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rawiwan_final_app/api/services.dart';
import 'package:table_calendar/table_calendar.dart';

class UserSchedulePage extends StatefulWidget {
  final String uid;

  const UserSchedulePage({super.key, required this.uid});

  @override
  _UserSchedulePageState createState() => _UserSchedulePageState();
}

class _UserSchedulePageState extends State<UserSchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Schedule'),
        foregroundColor: const Color(0xFFA50104),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rawiwan_users')
            .doc(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No schedule found.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final schedule =
              List<Map<String, dynamic>>.from(userData['schedule'] ?? []);

          Set<DateTime> scheduleDates = schedule
              .map((movie) {
                try {
                  final date = DateTime.parse(movie['dateTime']).toLocal();
                  return DateTime(date.year, date.month, date.day);
                } catch (e) {
                  debugPrint('Error parsing dateTime: ${movie['dateTime']}');
                  return null;
                }
              })
              .where((date) => date != null)
              .cast<DateTime>()
              .toSet();

          final filteredMovies = schedule.where((movie) {
            try {
              final movieDate = DateTime.parse(movie['dateTime']).toLocal();
              return _selectedDay != null &&
                  movieDate.year == _selectedDay!.year &&
                  movieDate.month == _selectedDay!.month &&
                  movieDate.day == _selectedDay!.day;
            } catch (e) {
              debugPrint('Error filtering movie: ${movie['dateTime']}');
              return false;
            }
          }).toList();

          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 01, 01),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return _selectedDay != null &&
                      day.year == _selectedDay!.year &&
                      day.month == _selectedDay!.month &&
                      day.day == _selectedDay!.day;
                },
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFFFCBA04),
                    shape: BoxShape.circle,
                  ),
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, _) {
                    final normalizedDay =
                        DateTime(day.year, day.month, day.day);

                    if (scheduleDates.contains(normalizedDay)) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
                headerStyle: const HeaderStyle(
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Color(0xFFFCBA04),
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Color(0xFFFCBA04),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Movies for this day',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: filteredMovies.isEmpty
                      ? const Center(
                          child: Text(
                            'No movies in your schedule for this day.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(16),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 25,
                                  mainAxisSpacing: 3,
                                  childAspectRatio: 0.50,
                                ),
                                itemCount: filteredMovies.length,
                                itemBuilder: (context, index) {
                                  final movie = filteredMovies[index];
                                  final dateTime =
                                      DateTime.parse(movie['dateTime'])
                                          .toLocal();
                                  final formattedDateTime =
                                      '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

                                  return GestureDetector(
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            movie['img'],
                                            height: 280,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.remove_circle_rounded,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                            onPressed: () {
                                              removeMovieFromSchedule(
                                                uid: widget.uid,
                                                movieId: movie['movieId'],
                                                selectedDate: _selectedDay!,
                                                context: context,
                                                scheduleId: movie['scheduleId'],
                                              );
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 30,
                                          left: 8,
                                          right: 8,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                movie['title'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                formattedDateTime,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
