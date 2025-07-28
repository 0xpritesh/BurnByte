
import 'package:burnbyte/screens/splash/dashboradscreen/dashborad_screen.dart';
import 'package:burnbyte/screens/splash/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;

  Future<void> loginUser() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (email == savedEmail && password == savedPassword) {
      // Set login status
      await prefs.setBool('isLoggedIn', true);

      // Check if onboarding shown
      bool? seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

      if (!seenOnboarding) {
        await prefs.setBool('seenOnboarding', true);
        Get.offAll(() => OnboardingScreen());
      } else {
        Get.offAll(() => DashboardScreen());
      }
    } else {
      Get.snackbar("Error", "Invalid credentials");
    }
    isLoading.value = false;
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.setBool('seenOnboarding', false);
    Get.offAllNamed('/');
  }
}
