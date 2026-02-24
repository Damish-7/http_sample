import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_api_service.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class AuthController extends GetxController {

  var isLoading = false.obs;

  // LOGIN
  Future<void> login(String email, String password) async {
    isLoading.value = true;

    bool success = await AuthApiService.login(email, password);

    isLoading.value = false;

    if (success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);
      await prefs.setString("userEmail", email);

      Get.offAll(() => const HomeScreen());
    } else {
      Get.snackbar("Error", "Invalid credentials");
    }
  }

  // REGISTER
  Future<void> register(String email, String password) async {
    isLoading.value = true;

    bool success = await AuthApiService.register(email, password);

    isLoading.value = false;

    if (success) {
      Get.snackbar("Success", "Registration successful");
      Get.back(); // back to login
    } else {
      Get.snackbar("Error", "User already exists");
    }
  }

  // LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Get.offAll(() => LoginScreen());
  }
}
