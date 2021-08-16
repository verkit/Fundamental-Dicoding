import 'package:get/get_connect/connect.dart';
import 'package:restaurant/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiEndpoint {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';
  static String restaurants = baseUrl + '/list';
  static String restaurant(String id) => baseUrl + '/detail/$id';
  static String search(String query) => baseUrl + '/search?q=$query';
  static String image(String pictureId) => baseUrl + '/images/small/$pictureId';
  static String addReview = baseUrl + '/review';
}

class AppRepository extends GetConnect {
  Future<List<Restaurant>> getRestaurants({String? query}) async {
    var res = query == null ? await get(ApiEndpoint.restaurants) : await get(ApiEndpoint.search(query));
    List<dynamic> data = res.body['restaurants'];
    List<Restaurant> restaurants = data.map((e) => Restaurant.fromJson(e)).toList();
    return restaurants;
  }

  Future<Restaurant> getRestaurant(String id) async {
    var res = await get(ApiEndpoint.restaurant(id));
    Restaurant restaurant = Restaurant.fromJson(res.body['restaurant']);
    return restaurant;
  }

  Future<List<CustomerReview>> addReview(String id, CustomerReview review) async {
    var res = await post(
      ApiEndpoint.addReview,
      {
        'id': id,
        'name': review.name,
        'review': review.review,
      },
      headers: {
        'YOUR_API_KEY': '12345',
      },
      contentType: 'application/x-www-form-urlencoded',
    );
    List<dynamic> data = res.body['customerReviews'];
    List<CustomerReview> reviews = data.map((e) => CustomerReview.fromJson(e)).toList();
    return reviews;
  }

  Future<List<Restaurant>> getFavRestaurants({String? query}) async {
    var res = query == null ? await get(ApiEndpoint.restaurants) : await get(ApiEndpoint.search(query));
    List<dynamic> data = res.body['restaurants'];
    List<Restaurant> restaurants = data.map((e) => Restaurant.fromJson(e)).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var favorites = prefs.getStringList('favorites');
    return restaurants.where((element) => favorites!.contains(element.id!)).toList();
  }
}
