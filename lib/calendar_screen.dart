import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_management_app/favorites_screen.dart';
import 'package:task_management_app/completed_screen.dart';
import 'package:task_management_app/todaytask.dart';
import 'menu.dart'; // Import the menu.dart file here

class CalendarScreen extends StatefulWidget {
  final Function toggleTheme;  // Add toggleTheme as a parameter

  CalendarScreen({required this.toggleTheme});  // Accept toggleTheme in the constructor

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _selectedIndex = 3; // Calendar tab is selected by default
  CalendarFormat _calendarFormat = CalendarFormat.month; // Month view by default
  DateTime _focusedDay = DateTime.now();
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;

  // Handle tab selection and navigation
  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      // Navigate based on the selected index
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TodayTaskPage(toggleTheme: widget.toggleTheme)), // Pass toggleTheme here
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FavoritesScreen(toggleTheme: widget.toggleTheme)), // Pass toggleTheme here
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CompletedScreen(toggleTheme: widget.toggleTheme)), // Pass toggleTheme here
          );
          break;
        case 3:
        // Already on CalendarScreen, do nothing
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50], // Light purple background for screen
      appBar: AppBar(
        backgroundColor: Colors.purple[800], // Dark purple navbar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(Icons.check_circle, 'Tasks', 0),
            _buildNavButton(Icons.favorite, 'Favorites', 1),
            _buildNavButton(Icons.check_circle, 'Completed', 2),
            _buildNavButton(Icons.calendar_today, 'Calendar', 3),
          ],
        ),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer automatically
            },
          ),
        ),
      ),
      body: Column(
        children: [
          // Dropdown menus for year and month selection
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Year Dropdown
              DropdownButton<int>(
                value: _selectedYear,
                dropdownColor: Colors.purple[100], // Light purple dropdown background
                style: TextStyle(color: Colors.purple[800]), // Text color in dropdown items
                items: List.generate(
                  50,
                      (index) => DropdownMenuItem(
                    value: DateTime.now().year - 25 + index,
                    child: Text(
                      (DateTime.now().year - 25 + index).toString(),
                      style: TextStyle(color: Colors.purple[800]), // Item text color
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedYear = value!;
                    _focusedDay = DateTime(_selectedYear, _selectedMonth);
                  });
                },
              ),
              SizedBox(width: 10),
              // Month Dropdown
              DropdownButton<int>(
                value: _selectedMonth,
                dropdownColor: Colors.purple[100], // Light purple dropdown background
                style: TextStyle(color: Colors.purple[800]), // Text color in dropdown items
                items: List.generate(
                  12,
                      (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text(
                      DateTime(0, index + 1).month.toString(),
                      style: TextStyle(color: Colors.purple[800]), // Item text color
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedMonth = value!;
                    _focusedDay = DateTime(_selectedYear, _selectedMonth);
                  });
                },
              ),
            ],
          ),
          // Calendar container with a smaller, light purple background
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.purple[100], // Light purple background for calendar
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime(2000),
                lastDay: DateTime(2100),
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(color: Colors.purple[700]), // Purple month name
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.purple[700]), // Purple weekend days
                  weekdayStyle: TextStyle(color: Colors.purple[700]), // Purple weekdays
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.purple[300],
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.purple[400],
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.purple[700]),
                  defaultTextStyle: TextStyle(color: Colors.black),
                  outsideDaysVisible: false,
                  rowDecoration: BoxDecoration(
                    color: Colors.purple[200], // Slightly darker purple for week row
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: MenuDrawer(toggleTheme: widget.toggleTheme), // Pass toggleTheme to MenuDrawer
    );
  }

  // Custom widget to create navigation buttons
  Widget _buildNavButton(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        _onItemTapped(index);
      },
      child: Column(
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? Colors.white : Colors.purple[200],
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white, // White text color for navbar items
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
