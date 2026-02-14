import 'package:get/get.dart';
import 'package:http_sample/models/student_model.dart';
import 'package:http_sample/services/api_service.dart';

class StudentController extends GetxController {

  var studentList = <Student>[].obs;   // ✅ correct
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchStudents();
    super.onInit();
  }

  void addStudent(String name, String email, String course) async {
  isLoading.value = true;

  bool success =
      await ApiService.insertStudent(name, email, course);

  if (success) {
    fetchStudents(); // 🔥 refresh list
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

    isLoading.value = false;
  }

  void deleteStudent(String id) async {
  bool success = await ApiService.deleteStudent(id);

  if (success) {
    fetchStudents();  // 🔥 refresh list
  }
}


  
}
