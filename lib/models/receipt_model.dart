import 'dart:collection';
import 'package:digi_receipt/contants/service_constants.dart';
import 'package:digi_receipt/models/product.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ReceiptModel {
    final int _receipt_id;
    final String _vendor_name;
    final String _vendor_phone;
    final String _vendor_address;
    final DateTime _purchase_time;
    final double _total;
    final List<Product> _products;
    List<String> tags;
    final VoidCallback notify;

    ReceiptModel(this._receipt_id,this._vendor_name, this._vendor_address,
        this._vendor_phone, this._purchase_time, this._total, this._products,
        this.tags, this.notify);

    int get receipt_id => _receipt_id;
    String get vendor_name => _vendor_name;
    String get vendor_phone => _vendor_phone;
    String get vendor_address => _vendor_address;
    DateTime get purchase_time => _purchase_time;
    double get total => _total;
    UnmodifiableListView<Product> get items => UnmodifiableListView(_products);
    
    Future<bool> addTag(String tagName)async{
        String kPath = await getDBPath();
        Database db = await openDatabase(kPath);
        List<Map<String, Object?>> tagRow = await db.rawQuery('''SELECT COUNT(tag_name) as tags from tag WHERE tag_name ='${tagName.replaceAll("'", "''")}' ''');
        if(tagRow[0]['tags']!=0)return false;
        int tagId = await db.rawInsert('''INSERT INTO tag (tag_name) VALUES ('${tagName.replaceAll("'", "''")}'); ''');
        print("Tag id in table is:${tagId}");
        await db.rawInsert('''INSERT INTO receipt_tag (receipt_id, tag_id) VALUES (${receipt_id},${tagId})''');
        await db.close();
        tags.add(tagName);
        notify();

        return true;
    }

    Future<void> removeTag(String tagName)async{
        String kPath = await getDBPath();
        Database db = await openDatabase(kPath);

        List<Map<String, Object?>> tagRow = await db.rawQuery('''SELECT tag_id FROM tag WHERE tag_name = '${tagName.replaceAll("'", "''")}'; LIMIT 1''');
        int tagId = tagRow[0]['tag_id'] as int;
        await db.rawDelete('''DELETE FROM receipt_tag WHERE receipt_id = ${receipt_id} AND tag_id = ${tagId}''');
        await db.rawDelete('''DELETE FROM tag WHERE tag_id = ${tagId}''');
        tags.remove(tagName);
        notify();
    }
    Future<void> removeAllTags()async{
        String kPath = await getDBPath();
        Database db = await openDatabase(kPath);

        List<Map<String, Object?>> tagRow = await db.rawQuery('''SELECT tag_id FROM receipt_tag WHERE receipt_id = $_receipt_id;''');
        for (var row in tagRow) {
            await db.rawDelete('''DELETE FROM tag WHERE tag_id = ${row['tag_id']};''');
        }
        await db.rawDelete('''DELETE FROM receipt_tag WHERE receipt_id = $receipt_id;''');
        tags = [];
        notify();
    }

    bool searchTag(String query){
        for(var tag in tags){
            if(tag.toLowerCase().contains(query.toLowerCase()))return true;
        }
        return false;
    }

    bool searchProduct(String query){
        for(var product in _products){
            if(product.product_name.toLowerCase().contains(query.toLowerCase()))return true;
        }
        return false;
    }

     List<Product> productInRange(double low, double high){
        List<Product> products = [];
        for(var product in _products){
            double price = product.product_price;
            if(high >= price && price >= low ) products.add(product);
        }
        return products;
    }

    List<ReceiptModel> receiptTotalInRange(double low, double high){
        List<ReceiptModel> receiptsInRange = [];

        return receiptsInRange;
    }

}