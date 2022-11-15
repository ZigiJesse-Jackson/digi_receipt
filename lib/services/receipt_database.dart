import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// ignore: constant_identifier_names
const String k_receipt_table = '''
  CREATE TABLE receipt(
    receipt_id INTEGER PRIMARY KEY,
    vendor_name text,
    vendor_address text,
    vendor_phone_number text,
    purchase_time numeric,
    receipt_total real
    );''';

const String k_tag_table = '''
    CREATE TABLE tag(
      tag_id INTEGER PRIMARY KEY,
      tag_name text
    );
    ''';

const String k_product_table = '''
    CREATE TABLE product(
    product_id INTEGER PRIMARY KEY,
      product_name text,
      product_price real,
      quantity integer
    );
    ''';

const String k_receipt_tag_table ='''
    CREATE TABLE receipt_tag(
      receipt_id integer,
      tag_id integer,
    FOREIGN KEY(receipt_id) REFERENCES receipt(receipt_id),
      FOREIGN KEY(tag_id) REFERENCES tag(tag_id)
    );
    ''';

const String k_receipt_product = '''
    CREATE TABLE receipt_product(
      receipt_id integer,
      product_id integer,
    FOREIGN KEY(receipt_id) REFERENCES receipt(receipt_id),
      FOREIGN KEY(product_id) REFERENCES product(product_id)
    );
    ''';

/// create relevant [db] tables
Future<void> createDB(Database db, int version) async {
  // creating database with relevant tables in SQLite
  await db.execute(k_tag_table);

  await db.execute(k_receipt_table);


  await db.execute(k_product_table);

  await db.execute(k_receipt_tag_table);

  await db.execute(k_receipt_product);

  // products dummy data
  await db.rawInsert('''INSERT INTO product (product_id, product_name, product_price, quantity) VALUES (1,'coca-cola', 8.0, 2);''');
  await db.rawInsert('''INSERT INTO product (product_id,product_name, product_price, quantity) VALUES (2,'bread', 10.0, 1);''');
  await db.rawInsert('''INSERT INTO product (product_id,product_name, product_price, quantity) VALUES (3,'McVities Shortbread', 18.0, 2);''');
  await db.rawInsert('''INSERT INTO product (product_id,product_name, product_price, quantity) VALUES (4,'Sachet water bag', 10.0, 4);''');
  await db.rawInsert('''INSERT INTO product (product_id,product_name, product_price, quantity) VALUES (5,'Indomie medium', 5.0, 2);''');
  await db.rawInsert('''INSERT INTO product (product_id,product_name, product_price, quantity) VALUES (6,'frozen sausage', 18.0, 5);''');
  await db.rawInsert('''INSERT INTO product (product_id,product_name, product_price, quantity) VALUES (7,'Vita-milk', 12.0, 2);''');
  await db.rawInsert('''INSERT INTO product (product_id,product_name, product_price, quantity) VALUES (8,'Oreo', 6.0, 1);''');

  // receipts dummy data
  await db.rawInsert('''INSERT INTO receipt (receipt_id, vendor_name, vendor_address, vendor_phone_number, purchase_time, receipt_total) VALUES (1, 'Hosanna', 'Hosanna Hostel, Ashesi University, Berekuso', '0550908002', 1668203075, 62.5);''');
  await db.rawInsert('''INSERT INTO receipt (receipt_id, vendor_name, vendor_address, vendor_phone_number, purchase_time, receipt_total) VALUES (2, 'Dufie', 'Dufie Hostel, Ashesi University, Berekuso', '0550908102', 1668116675, 123);''');
  await db.rawInsert('''INSERT INTO receipt (receipt_id, vendor_name, vendor_address, vendor_phone_number, purchase_time, receipt_total) VALUES (3, 'Hosanna', 'Hosanna Hostel, Ashesi University, Berekuso', '0550908002', 1668351849, 30.5);''');

  // receipt product dummy data
  await db.rawInsert('''INSERT INTO receipt_product (receipt_id, product_id) VALUES (1,1);''');
  await db.rawInsert('''INSERT INTO receipt_product (receipt_id, product_id) VALUES (1,2);''');
  await db.rawInsert('''INSERT INTO receipt_product (receipt_id, product_id) VALUES (1,3);''');
  await db.rawInsert('''INSERT INTO receipt_product (receipt_id, product_id) VALUES (2,4);''');
  await db.rawInsert('''INSERT INTO receipt_product (receipt_id, product_id) VALUES (2,5);''');
  await db.rawInsert('''INSERT INTO receipt_product (receipt_id, product_id) VALUES (2,6);''');
  await db.rawInsert('''INSERT INTO receipt_product (receipt_id, product_id) VALUES (3,7);''');
  await db.rawInsert('''INSERT INTO receipt_product (receipt_id, product_id) VALUES (3,8);''');
}

/// initialize database in [filePath]
Future<Database> initDB(String filePath) async {
  print('Initializing database in ${filePath}');
  return await openDatabase(filePath, version: 1, onCreate: createDB);
}

/// open receipt database if it exists, initialize it otherwise.
Future<Database> getDatabase() async {
  // check if database already exists
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'receipt.db');
  if(await databaseExists(path)!= false){

    return await openDatabase(path);
  }
  print('Database does not exist');
  // create and initialize database if it does not exist
  var database = await initDB(path);
  return database;
}