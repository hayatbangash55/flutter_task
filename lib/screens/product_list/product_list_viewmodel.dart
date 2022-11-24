import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task/helper/database_helper.dart';
import 'package:flutter_task/helper/global_variables.dart';
import 'package:flutter_task/screens/cart_view/cart_model.dart';
import 'package:flutter_task/screens/product_list/product_list_model.dart';
import 'package:flutter_task/widgets/loader.dart';
import 'package:get/get.dart';

class ProductListViewModel extends GetxController {
  List<ProductListModel> productList = <ProductListModel>[].obs;
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
    getDataFromSqlFLite();
    getDataFromApi();
  }

  getDataFromSqlFLite() async {
    await db.loadCartData();
    calculateCartQuantity();
  }

  getDataFromApi() async {
    Loader.loader.value = true;
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await fireStore.collection('Products').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    productList.addAll(allData.map((e) => ProductListModel.fromJson(e as Map<String, dynamic>)));
    Loader.loader.value = false;
  }

  calculateCartQuantity() {
    GlobalVariables.cartCount.value = GlobalVariables.cartList.fold(0, (sum, next) => sum + next.quantity!);
  }

  addToCart(int index) {
    int valueIndex = GlobalVariables.cartList.indexWhere(
      (item) => item.id == productList[index].id,
    );

    if (valueIndex != -1) {
      CartModel model = GlobalVariables.cartList[valueIndex];
      model.quantity = (model.quantity! + 1);
      GlobalVariables.cartList[valueIndex] = model;
      db.updateCartItem(model);
    } else {
      CartModel model = CartModel(
        id: productList[index].id,
        image: productList[index].image,
        name: productList[index].name,
        price: productList[index].price,
        quantity: 1,
      );
      GlobalVariables.cartList.add(model);
      db.insertCartItem(model);
    }

    GlobalVariables.cartCount.value++;
  }
}
