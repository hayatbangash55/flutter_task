
import 'package:flutter_task/screens/product_list/product_list_model.dart';

class CartModel {
  late ProductListModel productListModel;
  late int quantity;


  CartModel(this.productListModel, this.quantity);

  CartModel.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'] ?? 0;
    productListModel = ProductListModel.fromJson(json['productListModel']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['productListModel'] = productListModel.toJson();
    data['quantity'] = quantity;
    return data;
  }
}
