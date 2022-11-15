import 'dart:collection';
import 'package:digi_receipt/models/product.dart';

class ReceiptModel {
    final int _receipt_id;
    final String _vendor_name;
    final String _vendor_phone;
    final String _vendor_address;
    final DateTime _purchase_time;
    final double _total;
    final List<Product> _products;
    List<String> tags;

    ReceiptModel(this._receipt_id,this._vendor_name, this._vendor_address,
        this._vendor_phone, this._purchase_time, this._total, this._products,
        this.tags);

    int get receipt_id => _receipt_id;
    String get vendor_name => _vendor_name;
    String get vendor_phone => _vendor_phone;
    String get vendor_address => _vendor_address;
    DateTime get purchase_time => _purchase_time;
    double get total => _total;
    UnmodifiableListView<Product> get items => UnmodifiableListView(_products);

}