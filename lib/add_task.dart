import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  AddTaskScreen({required this.onSave});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<String> _selectedDays = [];

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _selectDays() async {
    final List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Days"),
          content: SingleChildScrollView(
            child: Column(
              children: daysOfWeek.map((day) {
                return CheckboxListTile(
                  title: Text(day),
                  value: _selectedDays.contains(day),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedDays.add(day);
                      } else {
                        _selectedDays.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Done"),
            ),
          ],
        );
      },
    );
  }

  void _saveTask() {
    if (_titleController.text.isEmpty || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final newTask = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'dueDate': '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
      'time': _selectedTime!.format(context),
      'repeatDays': _selectedDays.join(', '),
    };
    widget.onSave(newTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            ListTile(
              title: Text(_selectedDate == null
                  ? 'Select Date'
                  : 'Date: ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}'),
              trailing: Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
            ListTile(
              title: Text(_selectedTime == null
                  ? 'Select Time'
                  : 'Time: ${_selectedTime!.format(context)}'),
              trailing: Icon(Icons.access_time),
              onTap: _selectTime,
            ),
            ListTile(
              title: Text(_selectedDays.isEmpty
                  ? 'Select Repeat Days'
                  : 'Repeat: ${_selectedDays.join(', ')}'),
              trailing: Icon(Icons.repeat),
              onTap: _selectDays,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}
