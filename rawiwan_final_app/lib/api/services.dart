import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:rawiwan_final_app/models/movie.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Movie>> fetchMovies() {
    return _firestore.collection('rawiwan_movies').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Movie.fromJson(doc.data())).toList(),
        );
  }
}

Future<void> addToScheduleForUser({
  required String uid,
  required String movieId,
  required String title,
  required String img,
  required String dateTime,
}) async {
  final userDoc =
      FirebaseFirestore.instance.collection('rawiwan_users').doc(uid);
  final String scheduleId = const Uuid().v4();
  try {
    await userDoc.update({
      'schedule': FieldValue.arrayUnion([
        {
          'scheduleId': scheduleId,
          'movieId': movieId,
          'title': title,
          'img': img,
          'dateTime': dateTime,
        }
      ])
    });

    print('Schedule updated successfully!');
  } catch (e) {
    await userDoc.set({
      'username': 'Default Username',
      'email': 'default@example.com',
      'schedule': [
        {
          'scheduleId': scheduleId,
          'movieId': movieId,
          'title': title,
          'img': img,
          'dateTime': dateTime,
        }
      ]
    });

    print('Document created and schedule added.');
  }
}

Future<void> checkScheduleConflict(
  String uid,
  String selectedDateTime,
  BuildContext context,
  Movie rawiwanMovie,
) async {
  final userDoc =
      FirebaseFirestore.instance.collection('rawiwan_users').doc(uid);
  final userSnapshot = await userDoc.get();
  if (userSnapshot.exists) {
    final userData = userSnapshot.data() as Map<String, dynamic>;
    final schedule =
        List<Map<String, dynamic>>.from(userData['schedule'] ?? []);

    final isConflict = schedule.any((movie) {
      final movieDateTime = movie['dateTime'] as String;
      return movieDateTime == selectedDateTime;
    });

    if (isConflict) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Time Already Exists"),
            content: const Text(
                "The selected time already exists in your schedule. Do you want to proceed?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await addToScheduleForUser(
                    uid: uid,
                    movieId: rawiwanMovie.id,
                    title: rawiwanMovie.title,
                    img: rawiwanMovie.img,
                    dateTime: selectedDateTime,
                  );
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Movie added to schedule')),
                  );
                },
                child: const Text("Yes"),
              ),
            ],
          );
        },
      );
    } else {
      await addToScheduleForUser(
        uid: uid,
        movieId: rawiwanMovie.id,
        title: rawiwanMovie.title,
        img: rawiwanMovie.img,
        dateTime: selectedDateTime,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Movie added to schedule')),
      );
    }
  }
}

Future<void> removeMovieFromSchedule({
  required String uid,
  required String movieId,
  required String scheduleId,
  required DateTime selectedDate,
  required BuildContext context,
}) async {
  final userDoc =
      FirebaseFirestore.instance.collection('rawiwan_users').doc(uid);
  final userSnapshot = await userDoc.get();

  if (userSnapshot.exists) {
    final userData = userSnapshot.data() as Map<String, dynamic>;
    final schedule =
        List<Map<String, dynamic>>.from(userData['schedule'] ?? []);

    schedule.removeWhere((movie) {
      return movie['movieId'] == movieId && movie['scheduleId'] == scheduleId;
    });

    await userDoc.update({
      'schedule': schedule,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Movie removed from your schedule')),
    );
  }
}
