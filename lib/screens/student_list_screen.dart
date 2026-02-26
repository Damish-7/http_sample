import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_sample/controller/student_controller.dart';
import 'package:http_sample/screens/add_student_screen.dart';

class StudentListScreen extends StatelessWidget {
  StudentListScreen({super.key});

  final StudentController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        //  SEARCH BAR
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              hintText: "Search by name, email or course",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: controller.searchStudent,
          ),
        ),

        // VERY IMPORTANT: Expanded
        Expanded(
          child: Obx(() {
            if (controller.filteredList.isEmpty) {
              return const Center(child: Text("No students found"));
            }

            return LayoutBuilder(
              builder: (context, constraints) {

                //  MOBILE
                if (constraints.maxWidth < 600) {
                  return ListView.builder(
                    itemCount: controller.filteredList.length,
                    itemBuilder: (context, index) {
                      return _studentCard(controller.filteredList[index]);
                    },
                  );
                }

                //  TABLET / DESKTOP
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: controller.filteredList.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3.2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return _studentCard(controller.filteredList[index]);
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }

  //  STUDENT CARD
  Widget _studentCard(student) {
    return Card(
      color: const Color.fromARGB(255, 249, 235, 222),
      child: ListTile(
        title: Text(student.name),
        subtitle: Text("${student.course}\n${student.email}"),
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
  }
}