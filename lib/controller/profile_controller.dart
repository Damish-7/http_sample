import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_api_service.dart';

class ProfileController extends GetxController {
  var userName         = "".obs;
  var userEmail        = "".obs;
  var dateOfBirth      = "".obs;
  var place            = "".obs;
  var isLoading        = false.obs;

  // Web uses bytes in memory — NOT file paths
  Rx<Uint8List?> profileImageBytes = Rx<Uint8List?>(null);

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  // ── LOAD: SharedPrefs first, then sync from API ───────────────────────
  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    userEmail.value   = prefs.getString("userEmail") ?? "";
    userName.value    = prefs.getString("userName") ?? "";
    dateOfBirth.value = prefs.getString("dateOfBirth") ?? "";
    place.value       = prefs.getString("place") ?? "";

    // Load cached image from SharedPrefs (stored as base64 string)
    final cachedImage = prefs.getString("profileImageBase64") ?? "";
    if (cachedImage.isNotEmpty) {
      profileImageBytes.value = base64Decode(cachedImage);
    }

    if (userEmail.value.isNotEmpty) {
      await _syncFromApi();
    }
  }

  // ── SYNC from API ─────────────────────────────────────────────────────
  Future<void> _syncFromApi() async {
    final data = await AuthApiService.getProfile(userEmail.value);
    if (data == null) return;

    final prefs = await SharedPreferences.getInstance();

    final name = data["name"] ?? "";
    final dob  = data["dob"] ?? "";
    final loc  = data["place"] ?? "";

    userName.value    = name;
    dateOfBirth.value = dob;
    place.value       = loc;

    await prefs.setString("userName", name);
    await prefs.setString("dateOfBirth", dob);
    await prefs.setString("place", loc);

    // Load image from API response (base64 → Uint8List)
    final b64 = data["profile_image"] ?? "";
    if (b64.isNotEmpty) {
      try {
        profileImageBytes.value = base64Decode(b64);
        await prefs.setString("profileImageBase64", b64);
      } catch (e) {
        print("Image decode error: $e");
      }
    }
  }

  // ── PICK IMAGE (Web compatible) ───────────────────────────────────────
  Future<void> pickProfileImage() async {
    try {
      print(" --> Opening file picker...");

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, // on web, this opens file picker
        imageQuality: 60,
        maxWidth: 400,
      );

      if (pickedFile == null) {
        print(" xx  No image selected");
        return;
      }

      print("🟢 File selected: ${pickedFile.name}");

      // Read as bytes (works on web)
      final bytes = await pickedFile.readAsBytes();
      final base64Str = base64Encode(bytes);

      // Update UI immediately
      profileImageBytes.value = bytes;

      // Cache in SharedPrefs
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("profileImageBase64", base64Str);

      // Upload to DB
      final success = await AuthApiService.updateProfile(
        email:              userEmail.value,
        name:               userName.value,
        dob:                dateOfBirth.value,
        place:              place.value,
        profileImageBase64: base64Str,
      );

      if (success) {
        print(" == Image saved to DB");
        Get.snackbar(
          "Photo Updated",
          "Profile picture changed successfully.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue.shade400,
          colorText: Colors.white,
        );
      } else {
        print("🔴 Failed to save image to DB");
        Get.snackbar(
          "Warning",
          "Photo updated locally but failed to sync to server.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade400,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("🔴 pickProfileImage error: $e");
      Get.snackbar(
        "Error",
        "Could not open file picker: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
  }

  // ── SAVE PROFILE ──────────────────────────────────────────────────────
  Future<void> saveProfile({
    required String name,
    required String dob,
    required String userPlace,
  }) async {
    isLoading.value = true;

    // Get cached base64 image
    final prefs = await SharedPreferences.getInstance();
    final imageBase64 = prefs.getString("profileImageBase64") ?? "";

    final success = await AuthApiService.updateProfile(
      email:              userEmail.value,
      name:               name,
      dob:                dob,
      place:              userPlace,
      profileImageBase64: imageBase64,
    );

    isLoading.value = false;

    if (success) {
      userName.value    = name;
      dateOfBirth.value = dob;
      place.value       = userPlace;

      await prefs.setString("userName", name);
      await prefs.setString("dateOfBirth", dob);
      await prefs.setString("place", userPlace);

      Get.snackbar(
        "Profile Updated",
        "Your profile has been saved successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Error",
        "Failed to update profile. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
  }

  // ── IMAGE SOURCE SHEET ────On web there's only one option — file picker (no camera)
  
  void showImageSourceSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Change Profile Photo",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color.fromARGB(232, 113, 213, 241),
                child: Icon(Icons.photo_library, color: Colors.black),
              ),
              title: const Text("Choose from Files"),
              subtitle: const Text("Pick an image from your computer"),
              onTap: () {
                Get.back();
                pickProfileImage();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
    );
  }
}