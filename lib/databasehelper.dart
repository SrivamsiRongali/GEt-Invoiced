import 'dart:io';
import 'package:invoiced/pojoclass.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._init();
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();
  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'qixdriverDataBase1.0.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE bookKeeperModel( roleid INTEGER,
 userid INTEGER,
 flow INTEGER,
   appToken STRING,
userFirstName STRING,
userMiddleName STRING,
userLastName STRING,
userEmailAddress STRING,
userMobileNumber STRING,
profileImage   VAR ,
gender STRING,
rolename STRING,
baseurl STRING
)''');
  }

  Future<List<Map<String, Object?>>> getbookkeepermodel() async {
    Database db = await instance.database;
    var results = await db.query('bookKeeperModel', orderBy: 'userid');
    print('$results');
    return results;
  }

  Future<int> add(BookKeeperModel bookKeeperModel) async {
    Database db = await instance.database;
    var results = await db.insert(
      'bookKeeperModel',
      bookKeeperModel.toMap(),
    );
    print("added userdata=$results");
    return results;
  }

  Future<int> remove() async {
    Database db = await instance.database;
    print('userdeleted');
    return await db.delete('bookKeeperModel');
  }

  Future<int> update(BookKeeperModel bookKeeperModel) async {
    Database db = await instance.database;
    var results = await db.update(
      'bookKeeperModel',
      bookKeeperModel.toMap(),
    );
    return results;
  }

  Future flow(BookKeeperModel bookKeeperModel, flow) async {
    Database db = await instance.database;
    var results = await db.rawQuery("UPDATE appData Set flow=$flow");
    return results;
  }
}
