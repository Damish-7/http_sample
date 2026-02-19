import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_sample/controller/student_controller.dart';
import 'package:http_sample/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder((){
        Get.put(StudentController());
      }),
      debugShowCheckedModeBanner: false
      ,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen() ,
    );
  }
}
