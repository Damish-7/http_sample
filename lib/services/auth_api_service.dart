import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApiService {
  static const baseUrl = "http://localhost:8888/student_api/";

  static Future<bool> register(String email, String password) async {
    final response = await http.post(
      Uri.parse("${baseUrl}register.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email" : email,
        "password" : password,
      }),
      );

      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        return data["status"] == "success";
      }
      return false;
  }

  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("${baseUrl}login.php"),
      headers:{"Content-Type" : "applcstion/json"},
      body: jsonEncode({
        "email" : email,
        "password": password,
      }),
    );

    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      return data["status"]  == "success";
    }
    return false;
  }

}