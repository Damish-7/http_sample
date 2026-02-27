import 'package:get/get.dart';
import 'package:http_sample/models/student_model.dart';
import 'package:http_sample/services/api_service.dart';

class StudentController extends GetxController {

  var studentList = <Student>[].obs; 
  var filteredList = <Student>[].obs; 
  var isLoading = false.obs;
  
  
  @override
  void onInit() {
    fetchStudents();
    super.onInit();
  }


  void addStudent(String name, String email, String course) async {
  isLoading.value = true;

  bool success =
      await ApiService.insertStudent(name, email, course, "Admin");

  if (success) {
    fetchStudents(); 
  }

  isLoading.value = false;
}


  void fetchStudents() async {
    isLoading.value = true;

    try {
      var data = await ApiService.getStudents();

      if (data != null) {
        studentList.value =
    data.map<Student>((e) => Student.fromJson(e)).toList();

      }
    } catch (e) {
      print("ERROR: $e");
    }
    filteredList.assignAll(studentList);
    isLoading.value = false;
  }

  //search
  void searchStudent(String query){
    if (query.isEmpty) {
      filteredList.assignAll(studentList);
    } else {
      filteredList.assignAll(
        studentList.where((student) => 
        student.name.toLowerCase().contains(query.toLowerCase()) ||
        student.email.toLowerCase().contains(query.toLowerCase()) ||
        student.course.toLowerCase().contains(query.toLowerCase())
        ),
      );
    }
  }

  void deleteStudent(String id) async {
  bool success = await ApiService.deleteStudent(id);

  if (success) {
    fetchStudents();  
  }
}
void updateStudent(
  String id,
  String name,
  String email,
  String course,
) async {

  bool success =
      await ApiService.updateStudent(id, name, email, course);

  if (success) {
    fetchStudents();
  }
}


// ADD BELOW YOUR EXISTING CODE

int get totalStudents => studentList.length;

Map<String, int> get courseStats {
  Map<String, int> data = {};

  for (var student in studentList) {
    data[student.course] = (data[student.course] ?? 0) + 1;
  }
  return data;
}


  
}
