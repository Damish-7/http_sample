import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
 static const baseUrl = "http://localhost:8888/student_api/";


  static Future<List<dynamic>?> getStudents() async {
  final response = await http.get(
    Uri.parse("${baseUrl}fetch.php"),
  );

  print("STATUS CODE: ${response.statusCode}");
  print("BODY: ${response.body}");

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return null;
  }
}


  static Future<bool> insertStudent(
    String name,
    String email,
    String course,
    String createdBy) async {

      

  final response = await http.post(
    Uri.parse("${baseUrl}insert.php"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
  "name": name,
  "email": email,
  "course": course,
  "created_by": createdBy,
}),
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data["status"] == "success";
  }
  return false;
}


 static Future<bool> deleteStudent(String id) async {
  final response = await http.post(
    Uri.parse("${baseUrl}delete.php"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"id": id}),
  );

  print("DELETE STATUS: ${response.statusCode}");
  print("DELETE BODY: ${response.body}");

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data["status"] == "success";
  }

  return false;
}




}