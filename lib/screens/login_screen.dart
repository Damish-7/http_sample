import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_sample/controller/auth_controller.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController controller = Get.put(AuthController());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              Image.asset(
                "assets/images/logo.png",
                height: 220,
                errorBuilder: (context, error, stackTrace) {
                  return const Text("Image not found!");
                },
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email required";
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password required";
                  }
                  if (value.length < 6) {
                    return "Minimum 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Obx(() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                        }
                      },
                      child: const Text("Login"),
                    )),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Get.to(() => RegisterScreen());
                },
                child: const Text("Don't have account? Register"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
