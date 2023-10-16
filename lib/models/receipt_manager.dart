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

        // parsing and creating receipt objects one at a time
        for (var recRow in receipt_list){
            List<Product> products = [];
            List<String> tags = [];
            // reading receipt products from db
            List<Map> productList = await db.rawQuery('SELECT product.product_id as pid,'
                ' product_name, product_price, quantity from product, receipt_product'
                ' where receipt_product.receipt_id = ${recRow['receipt_id']}  and '
                'product.product_id = receipt_product.product_id;');

            // parsing and creating list of receipt product objects
            for (var prodRow in productList) {
                Product p = Product(prodRow['pid'],
                    prodRow['product_name'],
                    prodRow['product_price'],
                    prodRow['quantity']);
                products.add(p);
            }
            // reading and storing receipt tags from db
            List<Map> tagList = await db.rawQuery('''SELECT tag_name from tag, receipt_tag
             WHERE receipt_tag.receipt_id = ${recRow['receipt_id']} ''');
            for (var tagRow in tagList) {
                String tag = tagRow['tag_name'];
                tags.add(tag);
            }

            // initializing and adding receipts to receipt manager

            // converting timestamp to date
            print(recRow['purchase_time']);
            int r_date = recRow['purchase_time'] == null? 0: recRow['purchase_time'] as int;
            DateTime receipt_date = DateTime.fromMillisecondsSinceEpoch(r_date * 1000);

            receipts.add(ReceiptModel(
                recRow['receipt_id'] as int,
                recRow['vendor_name'] as String,
                recRow['vendor_address'] as String,
                recRow['vendor_phone_number'].toString(),
                receipt_date,
                recRow['receipt_total'] as double,
                products,
                tags,
                notifyListeners
            ) );
        }
        await db.close();
        notifyListeners();

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

    Future<void> insert_Receipt(String filePath, Map<String, dynamic> map) async{
        Database db = await openDatabase(filePath);
        int lim = 0;
        await db.transaction((txn) async {
            var batch = txn.batch();
            // Inserting products
            for(Map<String, dynamic> prod in map['products']){
                batch.insert("product", prod);
                lim++;
            }
            // Inserting receipt
            batch.insert("receipt", {"vendor_name":map['vendor'] as String,
                "vendor_address":map['location'] as String,  "vendor_phone_number": map['phone'] as String,
                "purchase_time": map['time'] as int, "receipt_total": map['total_price'] as double});
            await batch.commit();
        });


        // retrieving product ids
        List<Map<String, Object?>> rowIDs = await db.rawQuery('''SELECT product_id as p_id FROM
   product ORDER BY product_id DESC LIMIT $lim''');
        // retrieving receipt id
        List<Map<String, Object?>> receiptID = await db.rawQuery('''SELECT max(receipt_id) as r_id FROM
   receipt ''');
        int receiptId = receiptID[0]['r_id'] as int;

        await db.transaction((txn) async {
            var batch = txn.batch();
            for(Map<String, dynamic> row in rowIDs){
                int productId = row['p_id'] as int;
                batch.insert("receipt_product", {'receipt_id': receiptId, 'product_id': productId});
            }
            await batch.commit();
        });
        notifyListeners();
        await db.close();
    }

}