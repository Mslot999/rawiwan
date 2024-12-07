import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rawiwan_final_app/api/services.dart';
import 'package:rawiwan_final_app/models/movie.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie rawiwan_movies;

  const MovieDetailPage({super.key, required this.rawiwan_movies});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(rawiwan_movies.title),
        foregroundColor: const Color(0xFFA50104),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFA50104)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  rawiwan_movies.img,
                  width: double.infinity,
                  height: 600,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rawiwan_movies.eps != 0
                            ? '${rawiwan_movies.title} EP.${rawiwan_movies.eps}'
                            : rawiwan_movies.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${rawiwan_movies.source} | ${rawiwan_movies.release} | ${rawiwan_movies.genre} | ${rawiwan_movies.length} mins',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        rawiwan_movies.synopsis,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Pick a Date',
                suffixIcon:
                    Icon(Icons.calendar_today, color: Color(0xFFA50104)),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    controller.text = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    ).toIso8601String();
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final uid = user.uid;
                      checkScheduleConflict(
                          uid, controller.text, context, rawiwan_movies);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User not logged in!')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please pick a date and time!')),
                    );
                  }
                },
                child: const Text('Add to Schedule'),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
