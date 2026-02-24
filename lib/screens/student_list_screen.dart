import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:http_sample/controller/student_controller.dart';
import 'package:http_sample/screens/add_student_screen.dart';

class StudentListScreen extends StatelessWidget {
  StudentListScreen({super.key});

  final StudentController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.studentList.isEmpty) {
        return const Center(child: Text("no students found"));
      }
      return ListView.builder(
      
        itemCount: controller.studentList.length,
        itemBuilder: (context, index) {
          var student = controller.studentList[index];

          return Card(
            color: const Color.fromARGB(255, 215, 238, 239),
            child: ListTile(
              title: Text(student.name),
              subtitle: Text("${student.course} \n${student.email}"),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Get.to(() => AddStudentScreen(student: student));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      controller.deleteStudent(student.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
