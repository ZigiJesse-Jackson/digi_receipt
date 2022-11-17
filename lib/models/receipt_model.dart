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
    
    Future<bool> addTag(String tag_name)async{
        String k_path = await getDBPath();
        Database db = await openDatabase(k_path);
        List<Map<String, Object?>> tag_row = await db.rawQuery('''SELECT COUNT(tag_name) as tags from tag WHERE tag_name ='${tag_name.replaceAll("'", "''")}' ''');
        if(tag_row[0]['tags']!=0)return false;
        int tag_id = await db.rawInsert('''INSERT INTO tag (tag_name) VALUES ('${tag_name.replaceAll("'", "''")}'); ''');
        print("Tag id in table is:${tag_id}");
        await db.rawInsert('''INSERT INTO receipt_tag (receipt_id, tag_id) VALUES (${receipt_id},${tag_id})''');
        await db.close();
        tags.add(tag_name);
        notify();
        return true;
    }

    void removeTag(String tag_name)async{
        String k_path = await getDBPath();
        Database db = await openDatabase(k_path);

        List<Map<String, Object?>> tag_row = await db.rawQuery('''SELECT tag_id FROM tag WHERE tag_name = '$tag_name') LIMIT 1''');
        int tag_id = tag_row[0]['tag_id'] as int;
        await db.rawDelete('''DELETE FROM receipt_tag WHERE receipt_id = ${receipt_id} AND tag_id = ${tag_id}''');
        await db.rawDelete('''DELETE FROM tag WHERE tag_id = ${tag_id}''');
        tags.remove(tag_name);
        notify();
    }


}