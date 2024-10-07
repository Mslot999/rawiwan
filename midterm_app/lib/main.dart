import 'package:midterm_app/pages/course/course_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product_provider.dart';
import 'models/user_provider.dart';
import 'pages/blank_page.dart';
import 'pages/course/cartview.dart';
import 'pages/course/course.dart';
import 'pages/course/favcourseview.dart';
import 'pages/course/mycourse.dart';
import 'pages/first_page.dart';
import 'pages/login.dart';
import 'pages/course/paymentview.dart';
import 'pages/recruit_page.dart';
import 'pages/signup_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()), 
        ChangeNotifierProvider(create: (_) => CourseProvider()), 
        
      ],
      child: miidterm_app(),
    ),
  );
}

class miidterm_app extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LevelUp_Miidterm',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF295F98)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/': (context) => NavigationMenu(),
        '/1': (context) => CoursePage(),
        '/2': (context) => CoursePage(),
        '/3': (context) => CoursePage(),
        '/4': (context) => CoursePage(),
        '/5': (context) => CoursePage(),
        '/6': (context) => CoursePage(),        
        '/courseDetail': (context) => CourseDetail(
          courseId: '', 
          courseName: '', 
          coursePrice: 0, 
          courseImage: '', 
          courseRating: 0, 
          tutorName: '',) ,
        '/cart': (context) => Cartview(), 
        '/payment': (context) => Paymentview(), 
        '/favoriteCourses': (context) => FavoriteCoursesView(),
      },
    );
  }
}


class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  List<Widget> _pages = [
    FirstPage(),
    RecruitPage(),
    MyCourseView(), 
    Blank(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'My Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'My Course',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Color(0xFFEAE4DD),
        selectedItemColor: Color(0xFF295F98),
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
