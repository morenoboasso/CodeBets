import 'package:codebets/pages/main_bottombar.dart';
import 'package:get/get.dart';

import 'main.dart';

class AppRoutes {
  static const String login = '/login';
  static const String mainScreen = '/mainScreen';

  static final routes = [
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: mainScreen, page: () =>  BottomNavigationBarWidget()),
  ];
}
