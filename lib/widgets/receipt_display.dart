import 'package:digi_receipt/widgets/tag.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../contants/style_constants.dart';
import '../models/receipt_model.dart';
import '../pages/receipt_screen.dart';

class ReceiptDisplay extends StatelessWidget {
  final ReceiptModel receipt;
  const ReceiptDisplay({
    required this.receipt,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          thickness: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receipt.vendor_name,
                  style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black45,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  DateFormat('yMMMMd').add_Hm().format(receipt.purchase_time),
                  style: const TextStyle(fontSize: 13, color: Colors.black38),
                ),
              ],
            ),
            TextButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceiptScreen(receipt: receipt)));
            }, child: const Text("View More")),
          ],
        ),
        Row(
          children: [
            const Text(
              "Tags",
              style: TextStyle(
                fontSize: 13,
                color: Colors.black38,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: SizedBox(
                height: 23,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [for( var tagName in receipt.tags) Tag(tag_name: tagName)],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black38,
                ),
              ),
              Text(
                "${receipt.total.toStringAsFixed(2)} GHS",
                style: kSubPaymentInfoStyle,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(
                Icons.share,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ],
    );
  }
}