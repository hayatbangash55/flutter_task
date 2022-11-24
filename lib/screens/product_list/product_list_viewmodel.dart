import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task/helper/database_helper.dart';
import 'package:flutter_task/helper/global_variables.dart';
import 'package:flutter_task/screens/cart_view/cart_model.dart';
import 'package:flutter_task/screens/product_list/product_list_model.dart';
import 'package:flutter_task/widgets/loader.dart';
import 'package:get/get.dart';

class ProductListViewModel extends GetxController {
  RxInt cartCount = 0.obs;
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
    getData();
  }

  getData() async {
    Loader.loader.value = true;
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await fireStore.collection('Products').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    productList.addAll(allData
        .map((e) => ProductListModel.fromJson(e as Map<String, dynamic>)));
    Loader.loader.value = false;
  }

  addToCart(int index) {
    cartCount.value++;
    db.insertCartItem(productList[index].toJson());
  }
}
