import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant/api.dart';
import 'package:restaurant/controller.dart';
import 'package:restaurant/router.dart';
import 'package:restaurant/storage.dart';
import 'package:restaurant/strings.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantScreen extends GetView<RestaurantController> {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.obx(
        (state) => Obx(
          () => CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: Get.height * 0.33,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(controller.restaurant.name!),
                  background: Image(
                    image: CachedNetworkImageProvider(ApiEndpoint.image(controller.restaurant.pictureId!)),
                    colorBlendMode: BlendMode.multiply,
                    color: Colors.black54,
                    fit: BoxFit.cover,
                  ),
                  centerTitle: true,
                ),
                actions: [
                  FutureBuilder<bool>(
                    future: LocalStorage().isFavorite(controller.restaurant.id!),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                          child: const Icon(FlutterRemix.heart_3_fill),
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                        );
                      } else {
                        return IconButton(
                          onPressed: () {
                            if (snapshot.data!) {
                              LocalStorage().removeFavorite(controller.restaurant.id!);
                            } else {
                              LocalStorage().setFavorite(controller.restaurant.id!);
                            }
                            controller.update();
                          },
                          icon: Icon(
                            FlutterRemix.heart_3_fill,
                            color: snapshot.data! ? Colors.orangeAccent : Colors.white,
                          ),
                        );
                      }
                    },
                  ),
                ],
                elevation: 0,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        runSpacing: 4,
                        spacing: 4,
                        children: List.generate(
                          controller.restaurant.categories!.length,
                          (index) => Chip(
                            backgroundColor: AppColor.primaryColor,
                            label: Text(
                              controller.restaurant.categories![index].name!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Row(
                          children: [
                            const Icon(
                              FlutterRemix.star_smile_fill,
                              size: 21,
                            ),
                            const SizedBox(width: 4),
                            Text(controller.restaurant.rating!.toString()),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () {
                                Get.toNamed(AppRouter.review);
                              },
                              child: Text(
                                'Lihat Review',
                                style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            FlutterRemix.map_pin_2_fill,
                            size: 21,
                          ),
                          const SizedBox(width: 4),
                          Text(controller.restaurant.city!)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12) + const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Makanan',
                    style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 12) + const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 4.0,
                    mainAxisExtent: 250,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: 'https://www.helpguide.org/wp-content/uploads/salad-in-takeout-box-fork-1536.jpg',
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
                              controller.restaurant.menus!.foods![index].name!,
                              style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w700, fontSize: 18),
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: controller.restaurant.menus!.foods!.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12) + const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Minuman',
                    style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 12) + const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 4.0,
                    mainAxisExtent: 250,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                'https://cdn-a.william-reed.com/var/wrbm_gb_food_pharma/storage/images/publications/food-beverage-nutrition/beveragedaily.com/article/2020/03/31/beverage-webinar-today-what-drinks-do-consumers-want/10866454-1-eng-GB/Beverage-webinar-today-What-drinks-do-consumers-want_wrbm_large.jpg',
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
                              controller.restaurant.menus!.drinks![index].name!,
                              style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w700, fontSize: 18),
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: controller.restaurant.menus!.drinks!.length,
                  ),
                ),
              ),
            ],
          ),
        ),
        onError: (error) => const Center(
          child: Text('Sedang terjadi kesalahan'),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReviewScreen extends GetView<RestaurantController> {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('Review', style: TextStyle(color: Colors.white)),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.dialog(
              SimpleDialog(
                contentPadding: const EdgeInsets.all(16) - const EdgeInsets.only(bottom: 12),
                children: [
                  const Text('Add Review', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Form(
                    key: controller.formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controller.namaCtlr,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: InputBorder.none,
                              errorBorder: InputBorder.none,
                            ),
                            validator: (val) {
                              if (val == '') {
                                return 'Name cannot be empty';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: controller.reviewCtlr,
                            decoration: const InputDecoration(
                              labelText: 'Review',
                              border: InputBorder.none,
                              errorBorder: InputBorder.none,
                            ),
                            validator: (val) {
                              if (val == '') {
                                return 'Review cannot be empty';
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              controller.addReview();
                            },
                            child: const Text('Submit'),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          child: const Icon(FlutterRemix.add_line),
        ),
        body: ListView.builder(
          itemCount: controller.restaurant.customerReviews!.length,
          itemBuilder: (_, i) {
            var review = controller.restaurant.customerReviews![i];
            return ListTile(
              leading: Icon(FlutterRemix.user_smile_fill, color: AppColor.primaryColor),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.name!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(review.review!),
                  Text(
                    review.date!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
