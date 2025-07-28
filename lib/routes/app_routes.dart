
import 'package:burnbyte/screens/auth/login_screen.dart';
import 'package:burnbyte/screens/auth/signup_screen.dart';
import 'package:burnbyte/screens/splash/dashboradscreen/dashborad_screen.dart';
import 'package:burnbyte/screens/splash/splash_screen.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

final List<GetPage> appPages = [
  GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
  GetPage(name: AppRoutes.login, page: () =>  LoginScreen()),
  GetPage(name: AppRoutes.signup, page: () =>  SignupScreen()),
  GetPage(name: AppRoutes.dashboard, page: () => const DashboardScreen()),
  // GetPage(name: AppRoutes.search, page: () => const SearchScreen()),
  //   GetPage(name: AppRoutes.profilescreen, page: () => const ProfileScreen()),

  // GetPage(name: AppRoutes.doctorDetails, page: () => const DoctorDetailScreen()),
];
class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String doctorDetails = '/doctor-details';
  static const String profilescreen = '/profile';

}
