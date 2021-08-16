import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant/controller.dart';
import 'package:restaurant/router.dart';
import 'package:restaurant/screens/home.dart';
import 'package:restaurant/strings.dart';
import 'package:restaurant/utils/connection.dart';

class FavoriteScreen extends GetView<FavoriteController> {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectionController _connection = Get.find<ConnectionController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: _connection.obx(
        (state) => _connection.hasInterNetConnection.value
            ? Obx(
                () => SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(FlutterRemix.arrow_left_s_line),
                            ),
                            Text(
                              'Your Favorite Resto',
                              style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w900,
                                fontSize: 21,
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: Get.width,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: controller.searchCtlr.value,
                            onChanged: (val) {
                              if (val.isEmpty) {
                                controller.search(val);
                                controller.getRestaurants();
                              }
                            },
                            onSubmitted: (val) {
                              controller.search(val);
                              controller.getRestaurants(query: val);
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                FlutterRemix.search_line,
                                color: Colors.black,
                                size: 20,
                              ),
                              suffixIcon: controller.search.isNotEmpty
                                  ? InkWell(
                                      onTap: () {
                                        controller.getRestaurants();
                                        controller.search('');
                                        controller.searchCtlr.value.clear();
                                      },
                                      child: const Icon(
                                        FlutterRemix.close_line,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    )
                                  : const SizedBox(),
                              hintText: 'Search restaurant',
                              hintStyle: const TextStyle(fontSize: 14),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        controller.obx(
                          (state) => GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              mainAxisExtent: 259,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.restaurants.length,
                            itemBuilder: (ctx, i) {
                              var restaurant = controller.restaurants[i];
                              return InkWell(
                                onTap: () {
                                  Get.toNamed(AppRouter.restaurant, arguments: restaurant.id);
                                },
                                child: RestaurantItem(restaurant),
                              );
                            },
                          ),
                          onEmpty: SizedBox(
                            height: Get.height * 0.6,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/no_data.png',
                                    width: Get.width * 0.6,
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('No favorites yet'),
                                ],
                              ),
                            ),
                          ),
                          onError: (error) => SizedBox(
                            height: Get.height * 0.6,
                            child: Center(
                              child: Text(error!),
                            ),
                          ),
                          onLoading: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              mainAxisExtent: 259,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            itemBuilder: (ctx, i) {
                              return const ShimmerRestaurantItem();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/no_internet.png', width: Get.width * 0.6),
                    const SizedBox(height: 4),
                    const Text('You are not connected to the internet'),
                  ],
                ),
              ),
        onLoading: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/search_signal.png', width: Get.width * 0.6),
              const SizedBox(height: 4),
              const Text('App checks the connection'),
            ],
          ),
        ),
        onEmpty: SizedBox(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/search_signal.png',
                  width: Get.width * 0.6,
                ),
                const SizedBox(height: 4),
                const Text('You are not connected to the internet'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
