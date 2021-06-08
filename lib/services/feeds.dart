import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
class Product {
  final int id;
  final String title;
  final int channelinfo;
  final String lowthumbnail;
  final String highthumbnail;
  static final columns = ["id",  "title", "channelinfo", "lowthumbnail","highthumbnail"];
  Product(this.id,  this.title,this.channelinfo, this.lowthumbnail, this.highthumbnail);
  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      data['id'],
      data['title'],
      data['channelinfo'],
      data['low thumbnail'],
      data['high thumbnail']
    );
  }
  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "channelinfo": channelinfo,
    "lowthumbnail": lowthumbnail,
    "highthumbnail":highthumbnail
  };
}


class SQLiteDbProvider {
  SQLiteDbProvider._();
  static final SQLiteDbProvider db = SQLiteDbProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    _database = await initDB();
    return _database;
  }
  initDB() async {
    Directory documentsDirectory = await
    getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ProductDB.db");
    // Delete any existing database:
    var exists=await databaseExists(path);
    if(!exists){
      try{
        await Directory(dirname(path)).create(recursive: true);
      }catch(_){}
    }

    return await openDatabase(
        path, version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE Product ("
                  "id TEXT PRIMARY KEY,"
                  "apiid TEXT,"
                  "title TEXT,"
                  "channelinfo TEXT,"
                  "lowthumbnail TEXT,"
                  "highthumbnail TEXT"")"
          );



        }
    );
  }
  Future<List<Product>> getAllProducts() async {
    final db = await database;
    List<Map> results = await db.query(
        "Product", columns: Product.columns, orderBy: "id ASC"
    );
    List<Product> products = new List();
    results.forEach((result) {
      Product product = Product.fromMap(result);
      products.add(product);
    });
    return products;
  }
  Future<Product> getProductById(int id) async {
    final db = await database;
    var result = await db.query("Product", where: "id = ", whereArgs: [id]);
    return result.isNotEmpty ? Product.fromMap(result.first) : Null;
  }
  insert(product) async {
    print("insert");
    print(product);
    final db = await database;
    var maxIdResult = await db.rawQuery("SELECT MAX(id)+1 as last_inserted_id FROM Product");
    var id = maxIdResult.first["last_inserted_id"];
    var result = await db.rawInsert(
        "INSERT Into Product (id, title, channelinfo, lowthumbnail, highthumbnail)"
            " VALUES (?, ?, ?, ?, ?)",
        [product.id, product.title, product.channelinfo, product.lowthumbnail,product.highthumbnail]
    );
    return result;
  }
  update(Product product) async {
    final db = await database;
    var result = await db.update(
        "Product", product.toMap(), where: "id = ?", whereArgs: [product.id]
    );
    return result;
  }
  delete(int id) async {
    final db = await database;
    db.delete("Product", where: "id = ?", whereArgs: [id]);
  }
}