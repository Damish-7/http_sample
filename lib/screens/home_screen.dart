import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
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
      appBar: AppBar(title: Text("Student Home")),

      body: Column(
        children: [
          /// 🔹 TEXTFIELDS
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Name"),
          ),

          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: "Email"),
          ),

          TextField(
            controller: courseController,
            decoration: InputDecoration(labelText: "Course"),
          ),

          /// 🔥 ADD BUTTON (ADD HERE)
          ElevatedButton(
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
            child: Text("Add Student"),
          ),

          /// 🔹 STUDENT LIST
          Expanded(
            child: Obx(() {
              if (controller.studentList.isEmpty) {
                return Center(child: Text("No Student Found"));
              }

              return ListView.builder(
                itemCount: controller.studentList.length,
                itemBuilder: (context, index) {
                  var student = controller.studentList[index];

                  return ListTile(
                    title: Text(student.name),
                    subtitle: Text(student.course),

                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
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
                            Get.back(); // close dialog
                          },
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
