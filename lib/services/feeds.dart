import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
class Product {
  final int id;
  final String apiid;
  final String title;
  final String channelinfo;
  final String lowthumbnail;
  final String highthumbnail;
  static final columns = ["id", "apiid", "title", "channelinfo", "lowthumbnail","highthumbnail"];
  Product(this.id,this.apiid,  this.title,this.channelinfo, this.lowthumbnail, this.highthumbnail);
  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      data['id'],data['apiid'],
      data['title'],
      data['channelinfo'],
      data['lowthumbnail'],
      data['highthumbnail']
    );
  }
  Map<String, dynamic> toMap() => {
    "id": id,
    "apiid": apiid,
    "title": title,
    "channelinfo": channelinfo,
    "lowthumbnail": lowthumbnail,
    "highthumbnail":highthumbnail
  };
}


class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();

    return _db;
  }
  initDB() async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "sqlite.db");
    // Delete any existing database:
    var exists=await databaseExists(dbPath);
    if(!exists){
      try{
        await Directory(dirname(dbPath)).create(recursive: true);
      }catch(_){}

    }
    //await deleteDatabase(dbPath);


    return await openDatabase(
        dbPath, version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE Product ("
                  "id INT PRIMARY KEY,"
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
    Database dbClient = await _instance.db;
    List<Map> results = await dbClient.query(
        "Product", columns: Product.columns, orderBy: "id ASC"
    );
    List<Product> products = new List();
    results.forEach((result) {
      Product product = Product.fromMap(result);
      print(result);
      products.add(product);
    });
    return products;
  }
  Future<Product> getProductById(int id) async {
    Database dbClient = await _instance.db;
    var result = await dbClient.query("Product", where: "id = ", whereArgs: [id]);
    return result.isNotEmpty ? Product.fromMap(result.first) : Null;
  }
  insert(product) async {
    Database dbClient = await _instance.db;
    var maxIdResult = await dbClient.rawQuery("SELECT MAX(id)+1 as last_inserted_id FROM Product");
    var id = maxIdResult.first["last_inserted_id"]==null?1:maxIdResult.first["last_inserted_id"];
    var result = await dbClient.rawInsert(
        "INSERT Into Product (id,apiid, title, channelinfo, lowthumbnail, highthumbnail)"
            " VALUES (?,?, ?, ?, ?, ?)",
        [id,product["id"], product["title"], product["channelname"], product["low thumbnail"],product["high thumbnail"]]
    );
    return result;
  }
  update(Product product) async {
    Database dbClient = await _instance.db;
    var result = await dbClient.update(
        "Product", product.toMap(), where: "id = ?", whereArgs: [product.id]
    );
    return result;
  }
  delete(int id) async {
    Database dbClient = await _instance.db;
    var result = await dbClient.delete("Product", where: "id = ?", whereArgs: [id]);
    return result;
  }
}