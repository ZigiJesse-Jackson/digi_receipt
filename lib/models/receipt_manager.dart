import 'package:digi_receipt/models/product.dart';
import 'package:digi_receipt/models/receipt_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import '../services/receipt_database.dart';




class ReceiptManager with ChangeNotifier{
    late List<ReceiptModel> receipts =[];
    ReceiptManager(){
        readFromDB();
    }
    int get length => receipts.length;

    void readFromDB()async{
        Database db = await getDatabase();
        // reading receipt information from db
        List<Map<String, Object?>> receipt_list = await db.rawQuery('SELECT * FROM receipt;');

        // parsing and creating receipt objects
        receipt_list.forEach((Map<String, Object?> rec_row) async {
            List<Product> products = [];
            List<String> tags = [];
            // reading receipt products from db
            List<Map> productList = await db.rawQuery('SELECT product.product_id as pid,'
                ' product_name, product_price, quantity from product, receipt_product'
                ' where receipt_product.receipt_id = ${rec_row['receipt_id']}  and '
                'product.product_id = receipt_product.product_id;');

            // parsing and creating list of receipt product objects
            for (var prodRow in productList) {
                Product p = Product(prodRow['pid'],
                    prodRow['product_name'],
                    prodRow['product_price'],
                    prodRow['quantity']);
                products.add(p);
            }

            List<Map> tagList = await db.rawQuery('''SELECT tag_name from tag, receipt_tag
             WHERE receipt_tag.receipt_id = ${rec_row['receipt_id']} ''');
            for (var tagRow in tagList) {
                String tag = tagRow['tag_name'];
                tags.add(tag);
            }


            // initializing and adding receipts to receipt manager

            // converting timestamp to date
            int r_date = rec_row['purchase_time'] as int;
            DateTime receipt_date = DateTime.fromMillisecondsSinceEpoch(r_date * 1000);

            receipts.add(ReceiptModel(
                rec_row['receipt_id'] as int,
                rec_row['vendor_name'] as String,
                rec_row['vendor_address'] as String,
                rec_row['vendor_phone_number'].toString(),
                receipt_date,
                rec_row['receipt_total'] as double,
                products,
                tags,
                notifyListeners
            ) );
            notifyListeners();
        });
    }

    /// Adds all receipts where [query] appears in tags, product names,
    /// vendor name or vendor address
    static List<ReceiptModel> searchReceipt(List<ReceiptModel> receipts, String? query){
        if(query==null || query.isEmpty) return receipts;
        List<ReceiptModel> results = [];
        for(var receipt in receipts){
            if( receipt.searchTag(query) || receipt.searchProduct(query) ||
             receipt.vendor_name.toLowerCase().contains(query.toLowerCase()) || receipt.vendor_address.toLowerCase().contains(query.toLowerCase())){
                results.add(receipt);
            }
        }
        return results;
    }

    List<Product> productsInRange(double? low, double? high){
        low ??= 0;
        high ??= double.infinity;
        List<Product> products = [];
        for(var receipt in receipts){
            products+= receipt.productInRange(low, high);
        }
        return products;
    }

    static List<ReceiptModel> receiptsInDateRange(List<ReceiptModel> receipts, DateTime? from, DateTime? to){
        if(receipts.isEmpty)return receipts;
        from ??= DateTime.fromMillisecondsSinceEpoch(0);
        to ??= DateTime.now();
        List<ReceiptModel> receiptsInRange = [];
        for(var receipt in receipts){
            DateTime receiptPurchaseTime = receipt.purchase_time;
            if(receiptPurchaseTime.isBefore(to) && receiptPurchaseTime.isAfter(from)){
                receiptsInRange.add(receipt);
            }
        }
        return receiptsInRange;
    }

    static List<ReceiptModel> receiptTotalInRange(List<ReceiptModel> receipts, double? low, double? high){
        if(receipts.isEmpty)return receipts;
        List<ReceiptModel> receiptsInRange = [];
        low ??= 0;
        high ??= double.infinity;
        for( var receipt in receipts){
            double total = receipt.total;
            if(total>=low && total<=high)receiptsInRange.add(receipt);
        }
        return receiptsInRange;
    }

}