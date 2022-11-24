import 'package:flutter_task/screens/cart_view/cart_model.dart';
import 'package:get/get.dart';

class GlobalVariables {



  static List<CartModel> cartList = <CartModel>[].obs;
  static RxDouble subTotal = 0.0.obs;
  static RxDouble total = 0.0.obs;
  static RxDouble discount = 0.0.obs;
}
