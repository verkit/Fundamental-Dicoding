import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant/api.dart';
import 'package:restaurant/controller.dart';
import 'package:restaurant/model.dart';
import 'package:restaurant/strings.dart';
import 'package:restaurant/utils/connection.dart';
import 'package:shimmer/shimmer.dart';

import '../router.dart';

class HomeScreen extends GetView<AppController> {
  const HomeScreen({Key? key}) : super(key: key);

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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'RestoKu',
                                  style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.w900, fontSize: 21, color: AppColor.primaryColor),
                                ),
                                const Text(
                                  'Recommendation restaurant for you',
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                controller.setReminder();
                              },
                              icon: Icon(controller.isReminder.value
                                  ? FlutterRemix.notification_3_fill
                                  : FlutterRemix.notification_3_line),
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: Get.width * 0.8,
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
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  if (controller.openFilter() == false) {
                                    controller.openFilter(true);
                                  } else {
                                    controller.clearFilter();
                                  }
                                },
                                child: Icon(
                                  controller.openFilter() == false
                                      ? FlutterRemix.filter_fill
                                      : FlutterRemix.filter_off_fill,
                                  // size: 18,
                                ),
                              ),
                            ),
                            Flexible(
                              child: IconButton(
                                onPressed: () {
                                  Get.toNamed(AppRouter.favorites);
                                },
                                icon: const Icon(FlutterRemix.heart_3_fill),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (controller.openFilter.value == true) ...[
                          SizedBox(
                            height: 36,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: const [
                                FilterItem(title: 'A to Z', filter: Filter.alphabet),
                                FilterItem(title: 'Z to A', filter: Filter.alphabetDescending),
                                FilterItem(title: 'High Rating', filter: Filter.highRate),
                                FilterItem(title: 'Low Rating', filter: Filter.lowRate),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
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
                                  const Text('Restaurant not found'),
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

class RestaurantItem extends StatelessWidget {
  const RestaurantItem(this.restaurant, {Key? key}) : super(key: key);

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl: ApiEndpoint.image(restaurant.pictureId!),
          imageBuilder: (context, imageProvider) => Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: imageProvider,
              ),
            ),
          ),
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 180,
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0) + const EdgeInsets.only(top: 6),
          child: Text(
            restaurant.name!,
            style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ),
        Row(
          children: [
            const Icon(
              FlutterRemix.star_smile_fill,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(restaurant.rating!.toString()),
            const SizedBox(width: 8),
            const Icon(
              FlutterRemix.map_pin_2_fill,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(restaurant.city!)
          ],
        ),
        // SizedBox(height: 16)
      ],
    );
  }
}

class ShimmerRestaurantItem extends StatelessWidget {
  const ShimmerRestaurantItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0) + const EdgeInsets.only(top: 6),
            child: Container(
              height: 21,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black,
              ),
            ),
          ),
          Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Icon(
                FlutterRemix.star_smile_fill,
                size: 18,
              ),
              const SizedBox(width: 4),
              const SizedBox(width: 8),
              const Icon(
                FlutterRemix.map_pin_2_fill,
                size: 18,
              ),
              const SizedBox(width: 4),
            ],
          ),
          // SizedBox(height: 16)
        ],
      ),
    );
  }
}

class FilterItem extends GetWidget<AppController> {
  const FilterItem({
    Key? key,
    required this.title,
    required this.filter,
  }) : super(key: key);

  final String title;
  final Filter filter;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          InkWell(
            onTap: () {
              controller.filter(filter);
            },
            child: Chip(
              label: Text(
                title,
                style:
                    TextStyle(color: controller.filterValue.value == filter.toString() ? Colors.white : Colors.black87),
              ),
              backgroundColor:
                  controller.filterValue.value == filter.toString() ? AppColor.primaryColor : Colors.grey[300],
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
