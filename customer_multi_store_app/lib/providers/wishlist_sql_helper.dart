// ignore_for_file: avoid_print

import 'package:customer_multi_store_app/providers/product_class.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class WishlistSQLHelper {
  static Database? _database;

  static Future<Database?> get getDatabase async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDatabase();
      return _database;
    }
  }

  static Future<Database> initDatabase() async {
    String path = p.join(await getDatabasesPath(), 'anas.db');
    return await openDatabase(version: 1, path, onCreate: _onCreate);
  }

  static Future _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
        CREATE TABLE wishlist_database(
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
        'onCreate was called for wishlist database____________________________________________________________________');
  }

  static Future<void> addWishItem(Product product) async {
    Database? db = await getDatabase;
    await db!.insert('wishlist_database', product.toMap());
    print(
        'database items are ${await db.query('wishlist_database')}________________________________________________________________');
  }

  static Future<List<Map>> loadWishItems() async {
    Database? db = await getDatabase;
    return await db!.query('wishlist_database');
  }

  static Future deleteWishItem(String id) async {
    Database? db = await getDatabase;
    await db!
        .delete('wishlist_database', where: 'documentId = ?', whereArgs: [id]);
    print(
        'database items are ${await db.query('wishlist_database')}________________________________________________________________');
  }

  static Future deleteAllItems() async {
    Database? db = await getDatabase;
    await db!.rawDelete('DELETE FROM wishlist_database');
  }
}
