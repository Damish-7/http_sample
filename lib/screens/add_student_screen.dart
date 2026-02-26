import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_sample/controller/student_controller.dart';
import 'package:http_sample/models/student_model.dart';

class AddStudentScreen extends StatefulWidget {
  final Student? student;

  const AddStudentScreen({super.key, this.student});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  late final Student? student;

  bool isEdit = false;
  String? studentId;

  final StudentController controller = Get.find();

  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<String> courses = [
    "Flutter",
    "Java",
    "Python",
    "Cyber Security",
    "AWS",
  ];

  String? selectedCourse;

  @override
  void initState() {
    super.initState();

    if (widget.student != null) {
      isEdit = true;
      studentId = widget.student!.id;

      namecontroller.text = widget.student!.name;
      emailcontroller.text = widget.student!.email;
      selectedCourse = widget.student!.course;
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(isEdit ? "Edit Student" : "Fill the student details"),
      backgroundColor: const Color.fromARGB(150, 254, 254, 202),
      
    ),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [

              TextFormField(
                controller: namecontroller,
                decoration: const InputDecoration(labelText: "Full name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Name required" : null,
              ),
      
              const SizedBox(height: 20),
      
              TextFormField(
                controller: emailcontroller,
                decoration: const InputDecoration(labelText: "email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "email required";
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return "enter valid email";
                  }
                  return null;
                },
              ),
      
              const SizedBox(height: 20),
      
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: " course"),
                value: selectedCourse,
                items: courses
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCourse = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select course";
                  }
                  return null;
                },
              ),
      
              const SizedBox(height: 20),
      
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final name = namecontroller.text.trim();
                    final email = emailcontroller.text.trim();
                    final course = selectedCourse!;
      
                    if (isEdit) {
                      controller.updateStudent(studentId!, name, email, course);
                    } else {
                      controller.addStudent(name, email, course);
                    }
      
                    Get.back(); // go back after saving
                  }
                },
                child: Text(isEdit ? "Update Student" : "Add Student"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
