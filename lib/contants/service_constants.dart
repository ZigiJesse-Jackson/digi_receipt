import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


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

Future<String> getDBPath()async{
  String dbPath = await getDatabasesPath();
  return join(dbPath, 'receipt.db');
}