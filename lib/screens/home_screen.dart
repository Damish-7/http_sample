import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_sample/controller/auth_controller.dart';
import 'package:http_sample/controller/profile_controller.dart';
import 'package:http_sample/controller/student_controller.dart';
import 'package:http_sample/screens/add_student_screen.dart';
import 'package:http_sample/screens/profile_screen.dart';
import 'package:http_sample/screens/student_list_screen.dart';
import 'package:http_sample/utils/responsive_layout.dart';
import 'package:http_sample/screens/dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.put(AuthController());
  final ProfileController profileController = Get.put(ProfileController());

  int currentIndex = 0;

  final pages = [
    DashboardScreen(),
    const AddStudentScreen(),
    StudentListScreen(),
  ];

  @override
  void initState() {
    Get.put(StudentController());
    super.initState();
  }

  // ── Profile avatar (web: MemoryImage) ─────────────────────────────────
  Widget _profileAvatar() {
    return Obx(() {
      final bytes = profileController.profileImageBytes.value;

      return GestureDetector(
        onTap: _showProfileOptions,
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            backgroundImage: bytes != null ? MemoryImage(bytes) : null,
            child: bytes == null
                ? const Icon(Icons.person,
                    color: Color.fromARGB(232, 113, 213, 241), size: 22)
                : null,
          ),
        ),
      );
    });
  }

  // ── Profile options bottom sheet ──────────────────────────────────────
  void _showProfileOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with avatar + info
            Obx(() {
              final bytes = profileController.profileImageBytes.value;
              return Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        const Color.fromARGB(232, 113, 213, 241),
                    backgroundImage:
                        bytes != null ? MemoryImage(bytes) : null,
                    child: bytes == null
                        ? const Icon(Icons.person,
                            size: 30, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profileController.userName.value.isNotEmpty
                              ? profileController.userName.value
                              : "No name set",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          profileController.userEmail.value,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                        if (profileController.place.value.isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 12, color: Colors.grey),
                              const SizedBox(width: 2),
                              Text(
                                profileController.place.value,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }),

            const Divider(height: 28),

            // Update photo
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color.fromARGB(232, 113, 213, 241),
                child: Icon(Icons.camera_alt, color: Colors.black),
              ),
              title: const Text("Update Profile Photo"),
              subtitle: const Text("Choose from your computer"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.back();
                profileController.pickProfileImage();
              },
            ),

            // Edit profile details
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color.fromARGB(232, 113, 213, 241),
                child: Icon(Icons.edit, color: Colors.black),
              ),
              title: const Text("Edit Profile Details"),
              subtitle: const Text("Name · Date of Birth · Place"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.back();
                Get.to(() => const ProfileScreen());
              },
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _profileAvatar(),
        leadingWidth: 56,
        title: const Text("STUDENT PORTAL !"),
        backgroundColor: const Color.fromARGB(232, 113, 213, 241),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
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

      body: ResponsiveLayout(
        mobile: pages[currentIndex],
        tablet: Row(
          children: [
            _sideNavigation(),
            Expanded(child: pages[currentIndex]),
          ],
        ),
        desktop: Row(
          children: [
            _sideNavigation(),
            Expanded(child: pages[currentIndex]),
          ],
        ),
      ),

      bottomNavigationBar: MediaQuery.of(context).size.width < 600
          ? BottomNavigationBar(
              backgroundColor: const Color.fromARGB(232, 113, 213, 241),
              selectedIconTheme: const IconThemeData(color: Colors.black),
              unselectedIconTheme: const IconThemeData(color: Colors.white70),
              currentIndex: currentIndex,
              onTap: (index) => setState(() => currentIndex = index),
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

  Widget _sideNavigation() {
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) => setState(() => currentIndex = index),
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