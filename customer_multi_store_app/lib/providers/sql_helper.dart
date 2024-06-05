// ignore_for_file: avoid_print

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:customer_multi_store_app/providers/product_class.dart';

class SQLHelper {
  static Database? _database;

  static Future<Database?> get getDatabase async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  static Future<Database> initDatabase() async {
    print('Initializing database...');
    String path = p.join(await getDatabasesPath(), 'shopping_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
        CREATE TABLE cart_items (
          documentId TEXT PRIMARY KEY,
          name TEXT,
          price DOUBLE,
          quantity INTEGER,
          inStock INTEGER,
          imagesUrl TEXT,
          supplierId TEXT
        )
      ''');

    await batch.commit();
    print(
        'on create was called_______________________________________________________________');
  }

  static Future<void> insertItem(Product product) async {
    Database? db = await getDatabase;
    await db!.insert('cart_items', product.toMap());
    print(
        'cart item are_________________________________________${await db.query('cart_items')}');
  }

  static Future<List<Map>> loadItems() async {
    Database? db = await getDatabase;
    return await db!.query('cart_items');
  }

  static Future deleteItem(String id) async {
    Database? db = await getDatabase;
    await db!.delete('cart_items', where: 'documentId = ?', whereArgs: [id]);
  }

  static Future deleteAllItems() async {
    Database? db = await getDatabase;
    await db!.rawDelete('DELETE FROM cart_items');
  }

  static Future updateItem(Product newProduct, String status) async {
    Database? db = await getDatabase;
    await db!
        .rawUpdate('UPDATE cart_items SET quantity=? WHERE documentId =?', [
      status == 'increment' ? newProduct.quantity + 1 : newProduct.quantity - 1,
      newProduct.documentId
    ]);
  }
}
