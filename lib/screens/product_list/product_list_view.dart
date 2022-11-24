import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/helper/global_variables.dart';
import 'package:flutter_task/screens/cart_view/cart_view.dart';
import 'package:flutter_task/screens/product_list/product_list_viewmodel.dart';
import 'package:flutter_task/widgets/custom_buttons.dart';
import 'package:flutter_task/widgets/loader.dart';
import 'package:get/get.dart';

class ProductListView extends StatelessWidget {
  ProductListView({Key? key}) : super(key: key);

  final ProductListViewModel viewModel = Get.put(ProductListViewModel());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  categoryName(),
                  const SizedBox(height: 2),
                  totalProduct(),
                  Divider(
                    height: 18,
                    color: Get.theme.primaryColor.withOpacity(0.2),
                  ),
                  productGridView(context),
                ],
              ),
            ),
            const Loader()
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      centerTitle: true,
      title: const Image(
        height: 28,
        width: 28,
        image: AssetImage('assets/images/logo1.png'),
        // fit: BoxFit.contain,
      ),
      actions: [
        Obx(
          () => Badge(
            showBadge: (GlobalVariables.cartCount.value>0) ? true : false,
            position: BadgePosition.topEnd(top: 10, end: 6),
            badgeContent: Text(
              GlobalVariables.cartCount.value.toString(),
              style: const TextStyle(
                fontSize: 8,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: IconButton(
              onPressed: () {
                Get.to(() => CartView());
              },
              icon: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ),
      ],
    );
  }

  Widget categoryName() {
    return const Text(
      'Product List',
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        fontFamily: 'Palatino',
      ),
    );
  }

  Widget totalProduct() {
    return Obx(
      () => Text(
        'No of Items: ${viewModel.productList.length.toString()}',
        style: const TextStyle(
          fontSize: 10,
        ),
      ),
    );
  }

  Widget productGridView(BuildContext context) {
    return Obx(
      () => viewModel.productList.isNotEmpty
          ? Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: viewModel.productList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return productGridViewItem(index);
                },
              ),
            )
          : const Expanded(
              child: Center(
                child: Text('No Product available'),
              ),
            ),
    );
  }

  Widget productGridViewItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gridViewImage(index),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            viewModel.productList[index].name != null
                ? viewModel.productList[index].name!.toUpperCase()
                : 'N/A',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          viewModel.productList[index].price != null
              ? 'Rs: ${viewModel.productList[index].price!}'
              : 'N/A',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        addToCartButton(index),
      ],
    );
  }

  Widget gridViewImage(int index) {
    return Flexible(
      child: CachedNetworkImage(
        imageUrl: viewModel.productList[index].image ?? '',
        imageBuilder: (context, imageProvider) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: const Color(0xffDEDADA),
                width: 0.5,
              ),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
              ),
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: const Color(0xffDEDADA)),
              image: const DecorationImage(
                image: AssetImage('assets/images/default_image.png'),
                fit: BoxFit.fill,
              ),
            ),
          );
        },
        placeholder: (context, url) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: Get.theme.primaryColor,
            ),
          );
        },
      ),
    );
  }

  Widget addToCartButton(int index) {
    return CustomElevatedBtn(
      height: 29.5,
      backgroundColor: const Color(0xffba8d7d),
      radius: 4.5,
      child : const Text(
        'Add To Cart',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      onPressed: () {
        viewModel.addToCart(index);
      },
    );
  }
}
