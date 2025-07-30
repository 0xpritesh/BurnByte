import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/colors.dart';
import '../../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

 final List<Map<String, String>> onboardingData = [
  {
    "title": "Track Your Fitness",
    "desc": "Stay updated with your daily activities and progress.",
    "lottie": "https://lottie.host/6196b6af-7f95-446c-b223-db5f1c1b5f44/EUC8RmRvZ1.json",
  },
  {
    "title": "Set Daily Goals",
    "desc": "Set and achieve your personal fitness goals.",
    "lottie": "https://lottie.host/45e245f5-9f41-432f-84ca-ea7c42c92c90/fmXExsfzgs.json",
  },
  {
    "title": "Measure Calories",
    "desc": "Keep track of calories burned every day.",
    "lottie": "https://lottie.host/043f0a4b-5f84-4df2-b250-8f5fb5f8ee99/mZj13KlziA.json",
  },
  {
    "title": "Step Counter",
    "desc": "Monitor your daily steps with accuracy.",
    "lottie": "https://lottie.host/0072967b-0002-433c-91ae-3cc68cf9c26d/TP3Ezr6HSm.json",
  },
];


  void _onFinish() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  Widget _buildPageContent(Map<String, String> data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.network(data["lottie"]!, height: 250),
      const SizedBox(height: 30),
      Text(
        data["title"]!,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
      ),
      const SizedBox(height: 15),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          data["desc"]!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    ],
  );
}


  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingData.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentIndex == index ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? AppColors.primaryColor
                : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body:Container(
   decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF008080), // Teal
              Color(0xFF4B0082), // Indigo
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
  child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (_, index) =>
                    _buildPageContent(onboardingData[index]),
              ),
            ),
            _buildIndicators(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: _currentIndex == onboardingData.length - 1
                    ? _onFinish
                    : () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(
                  _currentIndex == onboardingData.length - 1 ? "Finish" : "Next",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }
}
