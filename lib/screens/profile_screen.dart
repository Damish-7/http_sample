import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_sample/controller/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.find<ProfileController>();

  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _placeController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController  = TextEditingController(text: profileController.userName.value);
    _dobController   = TextEditingController(text: profileController.dateOfBirth.value);
    _placeController = TextEditingController(text: profileController.place.value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color.fromARGB(232, 113, 213, 241),
            onPrimary: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _dobController.text =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color.fromARGB(232, 113, 213, 241),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ── Profile Photo ────────────────────────────────────────
              Center(
                child: Stack(
                  children: [
                    Obx(() {
                      final bytes = profileController.profileImageBytes.value;
                      return CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            const Color.fromARGB(232, 113, 213, 241),
                        backgroundImage:
                            bytes != null ? MemoryImage(bytes) : null,
                        child: bytes == null
                            ? const Icon(Icons.person,
                                size: 60, color: Colors.white)
                            : null,
                      );
                    }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: profileController.pickProfileImage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.black87,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              Obx(() => Text(
                    profileController.userEmail.value,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  )),

              const SizedBox(height: 28),

              // ── Form Card ────────────────────────────────────────────
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Personal Information",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 24),

                      _buildLabel("Full Name"),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration(
                            "Enter your name", Icons.person_outline),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? "Name is required"
                            : null,
                      ),

                      const SizedBox(height: 18),

                      _buildLabel("Date of Birth"),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _dobController,
                        readOnly: true,
                        onTap: _selectDate,
                        decoration: _inputDecoration(
                            "DD/MM/YYYY", Icons.calendar_today_outlined),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? "Please select DOB"
                            : null,
                      ),

                      const SizedBox(height: 18),

                      _buildLabel("Place / City"),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _placeController,
                        decoration: _inputDecoration(
                            "Enter your city", Icons.location_on_outlined),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? "Place is required"
                            : null,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Save Button ──────────────────────────────────────────
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: profileController.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.black),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        profileController.isLoading.value
                            ? "Saving..."
                            : "Save Profile",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(232, 113, 213, 241),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: profileController.isLoading.value
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                profileController.saveProfile(
                                  name: _nameController.text.trim(),
                                  dob: _dobController.text.trim(),
                                  userPlace: _placeController.text.trim(),
                                );
                              }
                            },
                    ),
                  )),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black54),
      );

  InputDecoration _inputDecoration(String hint, IconData icon) =>
      InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.black45),
        filled: true,
        fillColor: const Color(0xFFF0F4F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Color.fromARGB(232, 113, 213, 241), width: 1.5),
        ),
      );
}