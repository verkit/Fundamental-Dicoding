import 'dart:async';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:restaurant/api.dart';
import 'package:restaurant/model.dart';
import 'package:restaurant/strings.dart';
import 'package:restaurant/utils/background_service.dart';
import 'package:restaurant/utils/time_helper.dart';

/// Controller for this app
class AppController extends GetxController with StateMixin<List<Restaurant>> {
  final RxList<Restaurant> _restaurants = <Restaurant>[].obs;

  /// All data restaurant is here
  List<Restaurant> get restaurants => _restaurants;
  set restaurants(List<Restaurant> data) {
    _restaurants.value = data;
  }

  RxBool openFilter = false.obs;
  RxString filterValue = ''.obs;

  RxBool isReminder = false.obs;
  setReminder() async {
    isReminder.value = !isReminder.value;
    if (isReminder.value) {
      Get.snackbar('Reminder', 'Reminder has been turned on',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColor.primaryColor, colorText: Colors.white);
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      Get.snackbar('Reminder', 'Reminder have been turned off',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColor.primaryColor, colorText: Colors.white);
      return await AndroidAlarmManager.cancel(1);
    }
  }

  filter(Filter filter) {
    switch (filter) {
      case Filter.alphabet:
        restaurants.sort((a, b) => a.name!.compareTo(b.name!));
        break;
      case Filter.alphabetDescending:
        restaurants.sort((a, b) => b.name!.compareTo(a.name!));
        break;
      case Filter.highRate:
        restaurants.sort((a, b) => b.rating!.compareTo(a.rating!));
        break;
      case Filter.lowRate:
        restaurants.sort((a, b) => a.rating!.compareTo(b.rating!));
        break;
      default:
        // restaurants = tempData;
        break;
    }
    update();
    filterValue.value = filter.toString();
  }

  clearFilter() async {
    restaurants.clear();
    restaurants = await _repo.getRestaurants();
    filterValue.value = '';
    openFilter(false);
  }

  final AppRepository _repo = AppRepository();
  Future<void> getRestaurants({String? query}) async {
    change(null, status: RxStatus.loading());
    await _repo.getRestaurants(query: query).then((value) {
      restaurants = value;
      change(restaurants, status: restaurants.isEmpty ? RxStatus.empty() : RxStatus.success());
    }).onError((error, stackTrace) {
      change(null, status: RxStatus.error(error.toString()));
    });
  }

  RxString search = ''.obs;
  Rx<TextEditingController> searchCtlr = TextEditingController().obs;

  @override
  Future<void> onInit() async {
    await getRestaurants();
    super.onInit();
  }
}

enum Filter { alphabet, alphabetDescending, highRate, lowRate }

class RestaurantController extends GetxController with StateMixin<Restaurant> {
  final Rx<Restaurant> _restaurant = Restaurant().obs;
  Restaurant get restaurant => _restaurant.value;
  set restaurant(Restaurant val) {
    _restaurant.value = val;
  }

  final AppRepository _repo = AppRepository();
  Future<void> getRestaurant(String id) async {
    change(null, status: RxStatus.loading());
    await _repo.getRestaurant(id).then((value) {
      restaurant = value;
      change(restaurant, status: RxStatus.success());
    }).onError((error, stackTrace) {
      change(null, status: RxStatus.error(error.toString()));
    });
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController namaCtlr = TextEditingController();
  TextEditingController reviewCtlr = TextEditingController();
  Future addReview() async {
    if (formKey.currentState!.validate()) {
      CustomerReview review = CustomerReview(name: namaCtlr.text, review: reviewCtlr.text);
      var temp = await _repo.addReview(restaurant.id!, review);
      restaurant.customerReviews!.clear();
      restaurant.customerReviews!.addAll(temp);
      namaCtlr.clear();
      reviewCtlr.clear();
      Get.back();
      Get.back();
    }
  }

  @override
  void onInit() {
    getRestaurant(Get.arguments);
    super.onInit();
  }
}

class FavoriteController extends GetxController with StateMixin<List<Restaurant>> {
  final RxList<Restaurant> _restaurants = <Restaurant>[].obs;

  /// All data restaurant is here
  List<Restaurant> get restaurants => _restaurants;
  set restaurants(List<Restaurant> data) {
    _restaurants.value = data;
  }

  final AppRepository _repo = AppRepository();
  Future<void> getRestaurants({String? query}) async {
    change(null, status: RxStatus.loading());
    await _repo.getFavRestaurants(query: query).then((value) {
      restaurants = value;
      change(restaurants, status: restaurants.isEmpty ? RxStatus.empty() : RxStatus.success());
    }).onError((error, stackTrace) {
      change(null, status: RxStatus.error(error.toString()));
    });
  }

  RxString search = ''.obs;
  Rx<TextEditingController> searchCtlr = TextEditingController().obs;

  @override
  Future<void> onInit() async {
    await getRestaurants();
    super.onInit();
  }
}
