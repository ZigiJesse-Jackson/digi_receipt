import 'package:digi_receipt/contants/style_constants.dart' show kProductInfoStyle;
import 'package:flutter/material.dart';

class ReceiptItemTile extends StatelessWidget {
  final String item_name;
  final double price;
  final int quantity;
  const ReceiptItemTile({
    Key? key,
    required this.item_name,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item_name,
                      style: kProductInfoStyle,
                    ),
                    Text(
                      "${price.toStringAsFixed(2)} GHS",
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black38,
                          letterSpacing: 1.5),
                    )
                  ],
                ),
              ),

              Expanded(
                child: Text(
                  "Qty x $quantity",
                  style: kProductInfoStyle,
                  textAlign: TextAlign.center,
                ),
              ),

              Expanded(
                child: Text(
                  "${(price*quantity).toDouble().toStringAsFixed(2)} GHS",
                  style: kProductInfoStyle,
                  textAlign: TextAlign.end,
                ),
              ),

            ],
          ),
        ),
        Divider(
          height: 5,
          thickness: 1,
        ),
      ],
    );
  }
}