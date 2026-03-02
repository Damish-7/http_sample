import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthApiService {
  static const baseUrl = "http://localhost:8888/student_api/";

  // ── REGISTER ──────────────────────────────────────────────────────────
  // Matches register.php → json_decode(file_get_contents("php://input"), true)
  static Future<bool> register(String email, String password) async {
    final response = await http.post(
      Uri.parse("${baseUrl}register.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["status"] == "success";
    }
    return false;
  }

  // ── LOGIN ─────────────────────────────────────────────────────────────
  // Matches login.php → json_decode(file_get_contents("php://input"), true)
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("${baseUrl}login.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["status"] == "success";
    }
    return false;
  }

  // ── GET PROFILE ───────────────────────────────────────────────────────
  // Matches get_profile.php → json_decode(file_get_contents("php://input"), true)
  static Future<Map<String, dynamic>?> getProfile(String email) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}get_profile.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      print("GET PROFILE STATUS: ${response.statusCode}");
      print("GET PROFILE BODY: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["status"] == "success") return data;
      }
    } catch (e) {
      print("getProfile error: $e");
    }
    return null;
  }

  // ── UPDATE PROFILE ────────────────────────────────────────────────────
  // Matches update_profile.php → json_decode(file_get_contents("php://input"), true)
  static Future<bool> updateProfile({
    required String email,
    required String name,
    required String dob,
    required String place,
    String profileImageBase64 = "",
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}update_profile.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email"         : email,
          "name"          : name,
          "dob"           : dob,
          "place"         : place,
          "profile_image" : profileImageBase64,
        }),
      );

      print("UPDATE PROFILE STATUS: ${response.statusCode}");
      print("UPDATE PROFILE BODY: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data["status"] == "success";
      }
    } catch (e) {
      print("updateProfile error: $e");
    }
    return false;
  }

  // ── HELPER: File → Base64 ─────────────────────────────────────────────
  static Future<String> fileToBase64(String filePath) async {
    try {
      final bytes = await File(filePath).readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print("fileToBase64 error: $e");
      return "";
    }
  }

  // ── HELPER: Base64 → Local temp file ─────────────────────────────────
  static Future<String> base64ToFile(String base64Str, String fileName) async {
    try {
      if (base64Str.isEmpty) return "";
      final bytes = base64Decode(base64Str);
      final file = File("${Directory.systemTemp.path}/$fileName");
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      print("base64ToFile error: $e");
      return "";
    }
  }
}