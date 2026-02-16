import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_sample/controller/student_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final StudentController controller = Get.put(StudentController());

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final courseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Home")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// 🔹 NAME FIELD
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 EMAIL FIELD
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email Address",
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 COURSE FIELD
            TextField(
              controller: courseController,
              decoration: InputDecoration(
                labelText: "Course Name",
                prefixIcon: const Icon(Icons.menu_book),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 ADD BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.addStudent(
                    nameController.text,
                    emailController.text,
                    courseController.text,
                  );

                  nameController.clear();
                  emailController.clear();
                  courseController.clear();
                },
                child: const Text("Add Student"),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 STUDENT LIST
            Expanded(
              child: Obx(() {
                if (controller.studentList.isEmpty) {
                  return const Center(child: Text("No Student Found"));
                }

                return ListView.builder(
                  itemCount: controller.studentList.length,
                  itemBuilder: (context, index) {
                    var student = controller.studentList[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(student.name),
                        isThreeLine: true, // Allocates space for 3 lines total
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns text to the left
                          children: [Text(student.course), Text(student.email)],
                        ),

                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            Get.defaultDialog(
                              title: "Delete",
                              middleText:
                                  "Are you sure you want to delete this student?",
                              textConfirm: "Yes",
                              textCancel: "No",
                              confirmTextColor: Colors.white,
                              onConfirm: () {
                                controller.deleteStudent(student.id!);
                                Get.back();
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
