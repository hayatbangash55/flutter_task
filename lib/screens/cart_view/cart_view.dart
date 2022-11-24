import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task/helper/global_variables.dart';
import 'package:flutter_task/screens/cart_view/cart_viewmodel.dart';
import 'package:flutter_task/widgets/custom_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CartView extends StatelessWidget {
  CartView({Key? key}) : super(key: key);

  final CartViewModel viewModel = Get.put(CartViewModel());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: Obx(
          () => (GlobalVariables.cartList.isNotEmpty)
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      productListView(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Column(
                          children: [
                            promoCode(),
                            subTotal(),
                            discount(),
                            const Divider(height: 25),
                            total(),
                            buyNowButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : emptyCartView(),
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(CupertinoIcons.chevron_back),
      ),
      title: const Text('Cart'),
      elevation: 0,
    );
  }

  Widget productListView() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: GlobalVariables.cartList.length,
        itemBuilder: (context, int index) {
          return productListViewItem(index);
        },
      ),
    );
  }

  Widget productListViewItem(int index) {
    return Column(
      children: [
        Dismissible(
          direction: DismissDirection.endToStart,
          key: Key(GlobalVariables.cartList[index].id.toString()),
          onDismissed: (direction) {
            viewModel.deleteProduct(index);
          },
          background: Container(
            color: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            alignment: AlignmentDirectional.centerEnd,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                FaIcon(
                  FontAwesomeIcons.solidTrashCan,
                  color: Colors.white,
                  size: 16,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                image(index),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 1, bottom: 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  GlobalVariables.cartList[index]
                                              .name !=
                                          null
                                      ? GlobalVariables.cartList[index]
                                          .name!
                                      : 'N/A',
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  GlobalVariables.cartList[index]
                                      .price !=
                                      null
                                      ? 'Rs: ${GlobalVariables.cartList[index]
                                      .price!}'
                                      : 'N/A',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          GlobalVariables.cartList[index].id ?? '',
                          style: const TextStyle(
                            fontSize: 11.3,
                            fontWeight: FontWeight.w500,
                            color: Color(0xffB1B1B1),
                          ),
                        ),
                        cartCounter(index),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(thickness: 1, height: 0),
        ),
      ],
    );
  }

  Widget image(int index) {
    return SizedBox(
      height: 60,
      width: 60,
      child: CachedNetworkImage(
        imageUrl: GlobalVariables.cartList[index].image ?? '',
        imageBuilder: (context, imageProvider) {
          return Container(
            decoration: BoxDecoration(
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
              color: const Color(0xffCEFBF3),
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('assets/images/img4.png'),
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

  Widget cartCounter(int index) {
    return Obx(
      () => Row(
        children: [
          (GlobalVariables.cartList[index].quantity == 1)
              ? InkWell(
                  onTap: () {
                    viewModel.deleteProduct(index);
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.trashCan,
                    size: 13,
                  ),
                )
              : InkWell(
                  onTap: () {
                    viewModel.decrementProduct(index);
                  },
                  child: const Icon(
                    Icons.remove,
                    size: 17,
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              GlobalVariables.cartList[index].quantity.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: () {
              viewModel.incrementProduct(index);
            },
            child: Icon(
              Icons.add_circle_rounded,
              size: 17,
              color: Get.theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget promoCode() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xffECECEC),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              // controller: controller,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                border: InputBorder.none,
                hintText: 'Promo Code',
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffBDBDBD),
                ),
              ),
            ),
          ),
          applyButton(),
        ],
      ),
    );
  }

  Widget applyButton() {
    return CustomElevatedBtn(
      width: 80,
      height: 35,
      radius: 6,
      child: const Text(
        'Apply',
        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        // cartViewModel.stripeTesting();
      },
    );
  }

  Widget subTotal() {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Subtotal',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '0.0',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget discount() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Discount',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '0.0',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget total() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:  [
        const Text(
          'Total',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          viewModel.totalPrice.value.toString(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget buyNowButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: CustomElevatedBtn(
          width: 125,
          height: 35,
          radius: 30,
          child: const Text(
            'Buy Now',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          onPressed: () {

          },
        ),
      ),
    );
  }

  Widget emptyCartView(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/cart.svg',
            width: Get.width * 0.65,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 2, top: 20),
            child: Text(
              'Empty Cart',
              style: TextStyle(
                color: Color(0xffba8d7d),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const Text(
            'Please Add something in your cart',
            style: TextStyle(
              color: Color(0xffba8d7d),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          CustomElevatedBtn(
            width: Get.width * 0.5,
            height: 40,
            backgroundColor: const Color(0xffba8d7d),
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Shop now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
