import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_sample/controller/auth_controller.dart';
import 'package:http_sample/controller/student_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
   
    
  debugShowCheckedModeBanner: false,

   theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 242, 242, 182),
        scaffoldBackgroundColor: const Color.fromARGB(150, 254, 254, 202),
        
      ),

  initialBinding: BindingsBuilder(() {
    Get.put(AuthController(), permanent: true);
    Get.put(StudentController());
  }),

  home: isLoggedIn ? const HomeScreen() : LoginScreen(),
  
);

  }
}
