import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_ecommerce_app/views/main_layout.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  final emailError = ''.obs;
  final passwordError = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool validate() {
    bool isValid = true;
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Email validation
    if (email.isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Please enter a valid email address';
      isValid = false;
    } else {
      emailError.value = '';
    }

    // Password validation
    if (password.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (password.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    return isValid;
  }

  Future<void> login() async {
    if (!validate()) return;

    isLoading.value = true;
    
    // Simulate login network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    isLoading.value = false;

    Get.snackbar(
      'Welcome Back!',
      'Login successful',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF00C569),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );

    // Clear form and navigate to main dashboard layout
    emailController.clear();
    passwordController.clear();
    Get.offAll(() => const MainLayout());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
