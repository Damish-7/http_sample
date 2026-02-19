import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_sample/controller/student_controller.dart';
import 'package:http_sample/screens/add_student_screen.dart';
import 'package:http_sample/screens/student_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState()  => _HomeScreenState();

}
  
  class _HomeScreenState extends State<HomeScreen> {

    int currentIndex = 0;

    final pages = [
      const AddStudentScreen(),
      StudentListScreen(),
    ];

    @override
    void initState() {
      Get.put(StudentController());
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text("Student Management")),

        body: pages[currentIndex],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index){
            setState(() {
              currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              label: "add student ",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: "student List",
                ),
          ],
          ),
      );
    }
  }