import 'package:flutter/material.dart';
import 'package:task_manager_project_rafatvai/ui/screens/cancelled_task_screen.dart';
import 'package:task_manager_project_rafatvai/ui/screens/completed_task_screen.dart';
import 'package:task_manager_project_rafatvai/ui/screens/in_progress_task_screen.dart';
import 'package:task_manager_project_rafatvai/ui/screens/new_task_screen.dart';
import 'package:task_manager_project_rafatvai/ui/widgets/app_background.dart';

class BottomNavBaseScreen extends StatefulWidget {
  const BottomNavBaseScreen({super.key});

  @override
  State<BottomNavBaseScreen> createState() => _BottomNavBaseScreenState();
}

class _BottomNavBaseScreenState extends State<BottomNavBaseScreen> {

  @override

  int _selectedScreenIndex = 0;
  final List<Widget> _screens = [
    NewTaskScreen(),
    InProgressTaskScreen(),
    CancelledTaskScreen(),
    CompletedTaskScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: _screens[_selectedScreenIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        currentIndex: _selectedScreenIndex,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(
          color: Colors.green
        ),
        showUnselectedLabels: true,
        selectedItemColor: Colors.green,
        onTap: (int index){
          _selectedScreenIndex = index;
          if(mounted){
            setState(() {});
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add_chart_rounded), label: 'New Task',),
          BottomNavigationBarItem(icon: Icon(Icons.signal_wifi_statusbar_null), label: 'In Progress',),
          BottomNavigationBarItem(icon: Icon(Icons.cancel_outlined), label: 'Cancelled',),
          BottomNavigationBarItem(icon: Icon(Icons.task_alt_rounded), label: 'Completed',),
      ],
      ),
    );
  }
}
