import 'package:first_app/pages/fifth_page.dart';
import 'package:first_app/pages/first_page.dart';
import 'package:first_app/pages/fourth_page.dart';
import 'package:first_app/pages/second_page.dart';
import 'package:first_app/pages/seventh_page.dart';
import 'package:first_app/pages/sixth_page.dart';
import 'package:first_app/pages/third_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
 
void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,
);
runApp(const MyApp());
}
 
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 238, 109, 188)),
        useMaterial3: true,
      ),
      initialRoute: '/1',
      routes: {
        '/1': (context) => FirstPage(),
        '/2': (context) => SecondPage(),
        '/3': (context) => ThirdPage(),
        '/4': (context) => FourthPage(),
        '/5': (context) => FifthPage(),
        '/6': (context) => SixthPage(),
        '/7': (context) => SeventhPage(),
       
      },
    );
  }
}