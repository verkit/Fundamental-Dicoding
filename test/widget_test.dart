import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_connect/connect.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant/api.dart';
import 'package:restaurant/model.dart';

class GetApi extends GetConnect with Mock {}

Future<void> main() async {
  test('Apakah variabel sudah berhasil diparsing dari json ke model dengan benar', () async {
    final api = GetApi();
    var res = await api.get(ApiEndpoint.restaurant('rqdv5juczeskfw1e867'));
    Restaurant restaurant = Restaurant.fromJson(res.body['restaurant']);
    expect(restaurant, isA<Restaurant>());
  });
}
