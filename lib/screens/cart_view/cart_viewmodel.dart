import 'package:flutter_task/helper/database_helper.dart';
import 'package:flutter_task/helper/global_variables.dart';
import 'package:flutter_task/screens/cart_view/cart_model.dart';
import 'package:get/get.dart';

class CartViewModel extends GetxController {
  RxDouble totalPrice = 0.0.obs;
  DBHelper db = DBHelper();

  @override
  void onInit() {
    super.onInit();
    db = DBHelper();
    DBHelper.initDatabase();
  }

  @override
  void onReady() {
    super.onReady();
    calculateTotal();
  }

  deleteProduct(int index) {
    db.removeCartItem(GlobalVariables.cartList[index].id!);
    GlobalVariables.cartCount.value -=
        GlobalVariables.cartList[index].quantity!;
    GlobalVariables.cartList.removeAt(index);
    calculateTotal();
  }

  incrementProduct(int index) {
    CartModel model = GlobalVariables.cartList[index];
    model.quantity = (model.quantity! + 1);
    GlobalVariables.cartList[index] = model;
    db.updateCartItem(model);
    GlobalVariables.cartCount.value++;
    calculateTotal();
  }

  decrementProduct(int index) {
    if (GlobalVariables.cartList[index].quantity != 1) {
      CartModel model = GlobalVariables.cartList[index];
      model.quantity = (model.quantity! - 1);
      GlobalVariables.cartList[index] = model;
      db.updateCartItem(model);
    } else {
      deleteProduct(index);
    }
    GlobalVariables.cartCount.value--;
    calculateTotal();
  }

  calculateTotal() {
    totalPrice.value = GlobalVariables.cartList.fold(0, (sum, next) {
      return sum + (double.parse(next.price!) * next.quantity!);
    });
  }
}
