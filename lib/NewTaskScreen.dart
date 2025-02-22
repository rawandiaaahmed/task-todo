import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewTaskScreen extends StatefulWidget {
  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _taskController.addListener(_checkIfTextEntered);
  }

  void _checkIfTextEntered() {
    setState(() {
      _isButtonEnabled = _taskController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
    if (_isButtonEnabled) {
      await FirebaseFirestore.instance.collection('tasks').add({
        'task': _taskController.text,
        'completed': false,
        'time': DateTime.now().toIso8601String(),
      });
      Navigator.of(context).pop();
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'New task',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: "What are you planning?",
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  "May 29, 14:00", // You can implement date selection if needed
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.note_add_outlined, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  "Add note",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.category_outlined, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  "Category",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? _addTask : null,
                child: Text("Add Task"),
               
              ),
            ),
          ],
        ),
      ),
    );
  }
}