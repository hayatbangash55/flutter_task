import 'package:flutter_task/helper/database_helper.dart';
import 'package:get/get.dart';

class CartViewModel extends GetxController{


  DBHelper db = DBHelper();

  @override
  void onInit() {
    super.onInit();
    db = DBHelper();
    DBHelper.initDatabase();
    db.loadCartData();
  }


}