import 'package:flutter/material.dart';
import 'todaytask.dart'; // Import the TodayTaskPage
import 'menu.dart'; // Import MenuDrawer if used

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false; // Initial theme is light

  // Toggle the theme between light and dark mode
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(), // Theme toggle
      home: SplashScreen(toggleTheme: _toggleTheme), // Pass the toggle function to SplashScreen
    );
  }
}

class SplashScreen extends StatelessWidget {
  final Function toggleTheme;

  SplashScreen({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TodayTaskPage(toggleTheme: toggleTheme), // Pass toggleTheme to TodayTaskPage
        ),
      );
    });

    return Scaffold(
      backgroundColor: Colors.brown[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  'assets/image.webp',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
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
