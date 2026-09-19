import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_ecommerce_app/constants/app_colors.dart';
import 'package:flutter_ecommerce_app/controllers/auth_controller.dart';
import 'package:flutter_ecommerce_app/widgets/custom_button.dart';
import 'package:flutter_ecommerce_app/widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Gradient Orbs (Matching screenshot aesthetic)
          Positioned(
            bottom: -60,
            left: -40,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.25),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.15),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // Header Text
                    const Text(
                      'Hello Again!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Welcome back you've\nbeen missed!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Email Field
                    Obx(
                      () => CustomTextField(
                        controller: authController.emailController,
                        hintText: 'Enter email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        errorText: authController.emailError.value,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    Obx(
                      () => CustomTextField(
                        controller: authController.passwordController,
                        hintText: 'Password',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: !authController.isPasswordVisible.value,
                        errorText: authController.passwordError.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            authController.isPasswordVisible.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textLight,
                          ),
                          onPressed: authController.togglePasswordVisibility,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    // Recovery Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Recovery Password',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Sign In Button
                    Obx(
                      () => CustomButton(
                        text: 'Sign in',
                        isLoading: authController.isLoading.value,
                        onPressed: authController.login,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Divider: or continue with
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColors.border.withOpacity(0.8),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or continue with',
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppColors.border.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Social Buttons Row (Matching Image)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialCard(
                          child: const Text(
                            'G',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFEA4335),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildSocialCard(
                          child: const Icon(
                            Icons.apple,
                            size: 24,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildSocialCard(
                          child: const Icon(
                            Icons.facebook,
                            size: 24,
                            color: Color(0xFF1877F2),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),

                    // Footer Text: Not a member? Register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Not a member? ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Register now',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildSocialCard({required Widget child}) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}
