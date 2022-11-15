import 'package:digi_receipt/widgets/receipt_banner.dart';
import 'package:digi_receipt/contants/style_constants.dart';
import 'package:digi_receipt/widgets/receipt_tile.dart';
import 'package:digi_receipt/widgets/total_display.dart';
import 'package:digi_receipt/widgets/tag_display.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../models/receipt_model.dart';

class ReceiptScreen extends StatelessWidget {
  ReceiptModel receipt;
  ReceiptScreen({Key? key, required this.receipt}) : super(key: key);

  /// get receipt items total
  double getTotal() =>receipt.items.fold(0,(productTotal, curr)=>(curr.product_quantity*curr.product_price)+productTotal);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Nunito'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 ReceiptBanner(
                  vendor_name: receipt.vendor_name,
                  vendor_location: receipt.vendor_address,
                  vendor_mail: "",
                  vendor_number: receipt.vendor_phone,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 0),
                  child: TotalDisplay(
                    total_price: receipt.total,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TagsDisplay(
                    tags: receipt.tags,
                  ),
                ),
                const Divider(
                  height: 5,
                  thickness: 3,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for(Product p in receipt.items)
                      ReceiptItemTile(item_name: p.product_name, price: p.product_price, quantity: p.product_quantity)],
                  ),
                ),
                const Divider(
                  height: 5,
                  thickness: 3,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Subtotal",
                            style: kSubInfoStyle,
                          ),
                          Text(
                            "Fees Total",
                            style: kSubInfoStyle,
                          ),
                          Text(
                            "TOTAL",
                            style: kTotalStyle,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${getTotal().toStringAsFixed(2)} GHS",
                            style: kSubInfoStyle,
                          ),
                          Text(
                            "${(receipt.total - getTotal()).toStringAsFixed(2)} GHS",
                            style: kSubInfoStyle,
                          ),
                          Text("${receipt.total.toStringAsFixed(2)} GHS", style: kTotalStyle),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 5,
                  thickness: 3,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: Text(
                          "*Purchased on ${DateFormat('yMMMMd').add_Hm().format(receipt.purchase_time)}",
                          style: kSubPaymentInfoStyle),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}