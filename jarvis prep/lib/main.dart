import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(JarvisPrep());

class JarvisPrep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JARVIS Prep',
      theme: ThemeData.dark(),
      home: JarvisHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class JarvisHome extends StatefulWidget {
  @override
  _JarvisHomeState createState() => _JarvisHomeState();
}

class _JarvisHomeState extends State<JarvisHome> {
  List<String> tasks = [
    'Wake up at 5:00 AM',
    'Morning Study (5:30–6:45 AM)',
    'School (8:00–4:00)',
    'PW Class 1 (5:00–6:30 PM)',
    'PW Class 2 (7:00–8:30 PM)',
    'Night Study (9:00–11:00 PM)',
    'Daily Review & Planning'
  ];
  Map<String, bool> taskStatus = {};
  List<String> customTasks = [];
  TextEditingController taskController = TextEditingController();

  Timer? timer;
  int timeLeft = 50 * 60; // 50 minutes
  bool isRunning = false;

  String motivationalQuote = "Push yourself, because no one else will.";

  @override
  void initState() {
    super.initState();
    for (var t in tasks) taskStatus[t] = false;
    // Randomize motivational quote
    final quotes = [
      "Push yourself, because no one else will.",
      "Don’t stop until you're proud.",
      "Discipline is the bridge between goals and success.",
      "Focus on your goal. Don’t look in any direction but ahead.",
      "The pain you feel today will be the strength you feel tomorrow."
    ];
    motivationalQuote = (quotes..shuffle()).first;
  }

  String formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer?.cancel();
          isRunning = false;
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Time's up!"),
              content: Text("JARVIS: Great job, Commander."),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK"))
              ],
            ),
          );
        }
      });
    });
    isRunning = true;
  }

  void stopTimer() {
    timer?.cancel();
    isRunning = false;
    setState(() {
      timeLeft = 50 * 60;
    });
  }

  void addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        customTasks.add(taskController.text);
        taskStatus[taskController.text] = false;
        taskController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/icon.png', width: 32, height: 32),
            SizedBox(width: 12),
            Text('JARVIS Prep')
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Motivational Quote:", style: TextStyle(fontSize: 18)),
            Text("“$motivationalQuote”", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text("Your Routine", style: TextStyle(fontSize: 20)),
            ...[...tasks, ...customTasks].map((task) => CheckboxListTile(
                  title: Text(task),
                  value: taskStatus[task] ?? false,
                  onChanged: (val) {
                    setState(() {
                      taskStatus[task] = val ?? false;
                    });
                  },
                )),
            TextField(
              controller: taskController,
              decoration: InputDecoration(labelText: "Add custom task"),
              onSubmitted: (_) => addTask(),
            ),
            ElevatedButton(onPressed: addTask, child: Text("Add Task")),
            Divider(height: 40),
            Text("Study Timer", style: TextStyle(fontSize: 20)),
            Text(formatTime(timeLeft), style: TextStyle(fontSize: 40)),
            Row(
              children: [
                ElevatedButton(
                    onPressed: isRunning ? null : startTimer,
                    child: Text("Start Timer")),
                SizedBox(width: 10),
                ElevatedButton(
                    onPressed: isRunning ? stopTimer : null,
                    child: Text("Stop Timer"))
              ],
            )
          ],
        ),
      ),
    );
  }
}