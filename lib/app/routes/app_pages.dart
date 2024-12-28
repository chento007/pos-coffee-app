import 'package:coffee_app/app/pages/home_page.dart';
import 'package:coffee_app/app/pages/login_page.dart';
import 'package:get/get.dart';

class AppPages {
  static const INITIAL = '/login';

  static final routes = [
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(name: '/home', page: () => const HomePage()), 
  ];
}
