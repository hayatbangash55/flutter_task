class CartModel {
  String? image;
  String? name;
  String? id;
  String? price;
  int? quantity;


  CartModel({this.image, this.name, this.id, this.price, this.quantity});

  CartModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    id = json['id'];
    price = json['price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['id'] = id;
    data['price'] = price;
    data['quantity'] = quantity;
    return data;
  }
}