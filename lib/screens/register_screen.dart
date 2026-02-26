import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_sample/controller/auth_controller.dart';
import 'package:http_sample/utils/responsive_layout.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final AuthController controller = Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register"),
      backgroundColor: const Color.fromARGB(232, 113, 213, 241),
      ),

      body: ResponsiveLayout(
        mobile: _registerContent(context, false),
        tablet: _registerContent(context, true),
        desktop: _registerContent(context, true),
      ),
    );
  }

  // 🔹 SAME FORM, JUST RESPONSIVE
  Widget _registerContent(BuildContext context, bool isWide) {
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isWide ? 420 : double.infinity,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email required";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
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

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  Obx(() => controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.register(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                            }
                          },
                          child: const Text("Register"),
                        )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}