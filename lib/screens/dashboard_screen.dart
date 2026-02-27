import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_sample/controller/student_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final StudentController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔢 TOTAL STUDENTS CARD
            Card(
              color: Colors.blue.shade100,
              child: ListTile(
                leading: const Icon(Icons.people, size: 40),
                title: const Text(
                  "Total Students",
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  controller.totalStudents.toString(),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Students by Course",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // 🎓 COURSE STATS
            ...controller.courseStats.entries.map((entry) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(entry.key),
                  trailing: Text(
                    entry.value.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }
}