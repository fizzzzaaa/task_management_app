import 'package:flutter/material.dart';
import 'database.dart'; // Import your DatabaseHelper
import 'task_model.dart'; // Import your Task model
import 'todaytask.dart' as todaytask;
import 'package:path_provider/path_provider.dart';
import 'package:task_management_app/favorites_screen.dart' as favorites;
import 'package:task_management_app/completed_screen.dart';
import 'package:task_management_app/calendar_screen.dart';
import 'menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  final dbHelper = DatabaseHelper();
  await dbHelper.database; // This will initialize the database automatically
  runApp(MyApp()); // Run the app
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: SplashScreen(), // Set the splash screen as the initial route
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToTodayTask();
  }

  void _navigateToTodayTask() {
    Future.delayed(Duration(seconds: 3), () { // Display splash for 3 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TodayTaskPage()), // Navigate to TodayTaskPage after splash
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15), // Set the radius for rounded corners
              child: SizedBox(
                width: 100, // Set the desired width
                height: 100, // Set the desired height
                child: Image.asset(
                  'assets/image.webp',
                  fit: BoxFit.cover, // Adjust the image to fit the box
                ),
              ),
            ),
            SizedBox(height: 20), // Gap between text and image
            Text(
              'TO-Do Tasks',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
