import 'package:flutter_task/helper/global_variables.dart';
import 'package:flutter_task/screens/cart_view/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'cart.db'),
      version: 1,
      onCreate: onDatabaseCreate,
    );
  }

  static Future onDatabaseCreate(Database db, int version) async {
    await db.execute("create table Cart (id text primary key,image text,name text, price text, quantity integer)");
  }

  loadCartData() async {
    Database dbClient = await initDatabase();
    List<Map<String, dynamic>> maps = await dbClient.rawQuery('Select * From Cart');
    GlobalVariables.cartList.addAll(maps.map((e) => CartModel.fromJson(e)));
  }

  Future<int> insertCartItem(CartModel item) async {
    Database dbClient = await initDatabase();
    Map<String, dynamic> data = item.toJson();
    return await dbClient.insert('Cart', data);
  }

  Future<int> updateCartItem(CartModel item) async {
    Database dbClient = await initDatabase();
    Map<String, dynamic> data = item.toJson();
    return await dbClient.update('Cart', data, where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> removeCartItem(String id) async {
    Database dbClient = await initDatabase();
    return await dbClient.delete('Cart', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    Database dbClient = await initDatabase();
    dbClient.close();
  }
}
