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
    await db.execute('''CREATE TABLE bookKeeperModel( 
 userid INTEGER,
 flow INTEGER,
   appToken STRING,
userFirstName STRING,
userMiddleName STRING,
userLastName STRING,
userEmailAddress STRING,
userMobileNumber STRING,
profileImage  VAR ,
gender STRING,
rolename STRING,
baseurl STRING
)''');
    print('table created');
    await db
        .execute('''CREATE TABLE gstmodeofpayment( updateForBillPayment INTEGER,
  billPaymentId INTEGER, modeOfPaymentId INTEGER,paymentValue INTEGER)''');
    await db.execute(
        '''CREATE TABLE nongstmodeofpayment( updateForBillPayment INTEGER,
  billPaymentId INTEGER,modeOfPaymentId INTEGER,paymentValue INTEGER)''');
  }

  Future<List<Map<String, Object?>>> getbookkeepermodel() async {
    Database db = await instance.database;
    var results = await db.query('bookKeeperModel', orderBy: 'userid');

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

  Future<List<Map<String, Object?>>> getGSTmodeofpayments() async {
    Database db = await instance.database;
    var results =
        await db.query('gstmodeofpayment', orderBy: 'modeOfPaymentId');

    return results;
  }

  Future updateGSTmodeofpayment(int updateForBillPayment, int billPaymentId,
      int modeOfPaymentId, int paymentValue) async {
    Database db = await instance.database;
    var result = await db.rawQuery('''UPDATE  gstmodeofpayment
    Set updateForBillPayment = $updateForBillPayment,
        modeOfPaymentId = $modeOfPaymentId,
        paymentValue = $paymentValue 
        where modeOfPaymentId = $modeOfPaymentId And billPaymentId=$billPaymentId
      ''');

    return result;
  }

  Future deleteGSTmodeofpayment(int modeOfPaymentId) async {
    Database db = await instance.database;
    var result = await db.rawQuery('''DELETE FROM gstmodeofpayment
   
        WHERE billPaymentId=0 AND modeOfPaymentId = $modeOfPaymentId
      ''');

    return result;
  }

  Future deleteNonGSTmodeofpayment(int modeOfPaymentId) async {
    Database db = await instance.database;
    var result = await db.rawQuery('''DELETE FROM gstmodeofpayment
   
        WHERE billPaymentId=0 AND modeOfPaymentId = $modeOfPaymentId
      ''');

    return result;
  }

  Future updateNonGSTmodeofpayment(int updateForBillPayment, int billPaymentId,
      int modeOfPaymentId, int paymentValue) async {
    Database db = await instance.database;
    var result = await db.rawQuery('''UPDATE  nongstmodeofpayment
    Set updateForBillPayment= $updateForBillPayment,
        modeOfPaymentId=$modeOfPaymentId,
        paymentValue=$paymentValue 
        where modeOfPaymentId = $modeOfPaymentId And billPaymentId=$billPaymentId
      ''');

    return result;
  }

  Future<int> addGSTmodeofpayment(Gstmodeofpayment gstmodeofpayment) async {
    Database db = await instance.database;
    var results = await db.insert(
      'gstmodeofpayment',
      gstmodeofpayment.toMap(),
    );
    print("added userdata=$results");
    return results;
  }

  Future<int> removeGSTmodeofpayment() async {
    Database db = await instance.database;
    print('userdeleted');
    return await db.delete('gstmodeofpayment');
  }

  Future<List<Map<String, Object?>>> getNonGSTmodeofpayments() async {
    Database db = await instance.database;
    var results =
        await db.query('nongstmodeofpayment', orderBy: 'modeOfPaymentId');

    return results;
  }

  Future<int> addNonGSTmodeofpayment(
      Nongstmodeofpayment nongstmodeofpayment) async {
    Database db = await instance.database;
    var results = await db.insert(
      'nongstmodeofpayment',
      nongstmodeofpayment.toMap(),
    );
    print("added userdata=$results");
    return results;
  }

  Future<int> removenonGSTmodeofpayment() async {
    Database db = await instance.database;
    print('userdeleted');
    return await db.delete('nongstmodeofpayment');
  }
}
