import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_sample/controller/auth_controller.dart';
import 'package:http_sample/controller/student_controller.dart';
import 'package:http_sample/screens/add_student_screen.dart';
import 'package:http_sample/screens/student_list_screen.dart';
import 'package:http_sample/utils/responsive_layout.dart';
import 'package:http_sample/screens/dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find<AuthController>();

  int currentIndex = 0;

  final pages = [
    DashboardScreen(),
    const AddStudentScreen(),
    StudentListScreen(),
  ];

  @override
  void initState() {
    Get.put(StudentController()); // ensure controller exists
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("STUDENT PORTAL !"),
        backgroundColor: const Color.fromARGB(232, 113, 213, 241),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color.fromARGB(255, 0, 0, 0)),
            onPressed: () {
              Get.defaultDialog(
                title: "Logout",
                middleText: "Are you sure you want to logout?",
                textCancel: "No",
                textConfirm: "Yes",
                confirmTextColor: Colors.white,
                onConfirm: () {
                  Get.back();
                  authController.logout();
                },
              );
            },
          ),
        ],
      ),

      // 🔽 RESPONSIVE BODY
      body: ResponsiveLayout(
        // 📱 MOBILE
        mobile: pages[currentIndex],

        // 📲 TABLET
        tablet: Row(
          children: [
            _sideNavigation(),
            Expanded(child: pages[currentIndex]),
          ],
        ),

        // 💻 DESKTOP / WEB
        desktop: Row(
          children: [
            _sideNavigation(),
            Expanded(child: pages[currentIndex]),
          ],
        ),
      ),

      // 🔽 BOTTOM NAV ONLY FOR MOBILE
      bottomNavigationBar: MediaQuery.of(context).size.width < 600
          ? BottomNavigationBar(
              backgroundColor: const Color.fromARGB(232, 113, 213, 241),
              selectedIconTheme: const IconThemeData(color: Colors.black),
              unselectedIconTheme: const IconThemeData(color: Colors.white70),
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard, color: Colors.white),
                  label: "Dashboard",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_add, color: Colors.white),
                  label: "Add",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list, color: Colors.white),
                  label: "List",
                ),
              ],
            )
          : null,
    );
  }

  //  SIDE NAV FOR TABLET / DESKTOP
  Widget _sideNavigation() {
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      labelType: NavigationRailLabelType.all,
      backgroundColor: const Color.fromARGB(232, 113, 213, 241),
      selectedIconTheme: const IconThemeData(color: Colors.white),
      unselectedIconTheme: const IconThemeData(color: Colors.white70),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard),
          label: Text("Dashboard"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_add),
          label: Text("Add Student"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.list),
          label: Text("Student List"),
        ),
      ],
    );
  }
}
