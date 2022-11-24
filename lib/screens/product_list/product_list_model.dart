class ProductListModel {
  String? image;
  String? name;
  String? id;
  String? price;

  ProductListModel({this.image, this.name, this.id, this.price});

  ProductListModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    id = json['id'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['id'] = id;
    data['price'] = price;
    return data;
  }
}