import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:restaurant/binding.dart';
import 'package:restaurant/screens/favorite.dart';
import 'package:restaurant/screens/home.dart';
import 'package:restaurant/screens/restaurant.dart';
import 'package:restaurant/screens/splash.dart';

/// Router aplikasi
class AppRouter {
  // Nama routing
  static const String splash = '/splash';
  static const String homepage = '/home';
  static const String restaurant = '/restaurant';
  static const String review = '/review';
  static const String favorites = '/favorites';

  // List halaman
  static final pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: homepage, page: () => const HomeScreen(), transition: Transition.fade),
    GetPage(name: restaurant, page: () => const RestaurantScreen(), binding: RestaurantBinding()),
    GetPage(name: review, page: () => const ReviewScreen()),
    GetPage(name: favorites, page: () => const FavoriteScreen(), binding: FavoriteBinding()),
  ];
}
