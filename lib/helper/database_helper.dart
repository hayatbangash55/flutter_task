import 'package:flutter_task/screens/product_list/product_list_model.dart';
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
    await db.execute(
        "create table Cart (id text primary key,image text,name text, price text)");
  }

  Future<List<ProductListModel>> loadCartData() async {
    List<ProductListModel> data = [];
    Database dbClient = await initDatabase();
    List<Map<String, dynamic>> maps =
        await dbClient.rawQuery('Select * From Cart');
    if (maps.isNotEmpty) {
      for (var m in maps) {
        data.add(ProductListModel.fromJson(m));
      }
      return data;
    }
    return data;
  }

  Future<int> insertCartItem(Map<String, dynamic> item) async {
    Database dbClient = await initDatabase();
    return await dbClient.insert('Cart', item);
  }

  Future<int> updateCartItem(ProductListModel item) async {
    Database dbClient = await initDatabase();
    Map<String, dynamic> data = item.toJson();
    return await dbClient
        .update('Cart', data, where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> removeCartItem(int id) async {
    Database dbClient = await initDatabase();
    return await dbClient.delete('Cart', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    Database dbClient = await initDatabase();
    dbClient.close();
  }
}
