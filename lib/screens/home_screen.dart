import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_sample/controller/auth_controller.dart';
import 'package:http_sample/controller/student_controller.dart';
import 'package:http_sample/screens/add_student_screen.dart';
import 'package:http_sample/screens/student_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.put(AuthController());

  int currentIndex = 0;

  final pages = [const AddStudentScreen(), StudentListScreen()];

  @override
  void initState() {
    final StudentController controller = Get.find();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("STUDENT MANAGEMENT"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.defaultDialog(
                title: "Logout",
                middleText: "Are you sure you want to logout?",
                textCancel: "No",
                textConfirm: "Yes",
                confirmTextColor: Colors.white,
                onConfirm: () {
                  Get.back(); // close dialog
                  authController.logout();
                },
                onCancel: () {
                  Get.back(); // close dialog
                },
              );
            },
          ),
        ],
      ),

      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 78, 179, 188),
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: "Add student ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Student List",
          ),
        ],
      ),
    );
  }
}
