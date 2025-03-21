import 'package:LevelUp/firebase_options.dart';
import 'package:LevelUp/models/company_provider.dart';
import 'package:LevelUp/models/review_provider.dart';
import 'package:LevelUp/pages/course/course_detail.dart';
import 'package:LevelUp/pages/course/course_review.dart';
import 'package:LevelUp/pages/course/review.dart';
import 'package:LevelUp/pages/job/company_page.dart';
import 'package:LevelUp/pages/job/detail_page.dart';
import 'package:LevelUp/pages/job/favorite_page.dart';
import 'package:LevelUp/pages/job/myjob_page.dart';
import 'package:LevelUp/pages/job/sent_resume.dart';
import 'package:LevelUp/pages/profile/edit_profile.dart';
import 'package:LevelUp/pages/profile/profile_page.dart';
import 'package:LevelUp/pages/profile/view_profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product_provider.dart';
import 'models/user_provider.dart';
import 'pages/course/cartview.dart';
import 'pages/course/course.dart';
import 'pages/course/favcourseview.dart';
import 'pages/course/mycourse.dart';
import 'pages/first_page.dart';
import 'pages/login.dart';
import 'pages/course/paymentview.dart';
import 'pages/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (context) => CompanyProvider()),
      ],
      child: LevelUp(),
    ),
  );
}

class LevelUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LevelUp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF295F98)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => NavigationMenu(),
        '/1': (context) => CompanyPage(),
        '/2': (context) => CoursePage(),
        '/3': (context) => ProfilePage(),
        '/courseDetail': (context) => CourseDetail(
              courseId: '',
              courseName: '',
              coursePrice: 0,
              courseImage: '',
              courseRating: 0,
              tutorName: '',
              category: [],
              isFavorite: false,
              isPurchased: false,
            ),
        '/cart': (context) => Cartview(),
        '/payment': (context) => Paymentview(),
        '/favoriteCourses': (context) => FavoriteCoursesView(),
        '/job_detail': (context) => CompanyDetail(
              id: '',
              companyName: '',
              skillRequire: '',
              companyImage: '',
              companyRating: 0,
              salary: 0,
              description: '',
            ),
        '/editprofile': (context) => EditProfilePage(),
        '/viewprofile': (context) => ViewProfilePage(),
        '/fav': (context) => FavoriteCompaniesPage(),
        '/sen': (context) => SentResume(),
        '/review': (context) => AddReview(),
        '/course-reviews': (context) => CourseReviewsPage(),


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
    MyJobPage(),
    MyCourseView(),
    ProfilePage(),
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
