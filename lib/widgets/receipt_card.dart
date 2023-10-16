import 'package:digi_receipt/contants/style_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/receipt_model.dart';
import '../pages/receipt_screen.dart';

class ReceiptCard extends StatelessWidget {
  final ReceiptModel receipt;
  const ReceiptCard({
    Key? key,
    required this.receipt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              // shadows for receipt display
              boxShadow: [
                BoxShadow(
                  color: Colors.lightBlue.shade50,
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // section for price display
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 1,
                    blurRadius: 15,
                    offset: const Offset(2, 5),
                  )
                ], color: Colors.lightGreen.shade50, shape: BoxShape.circle),
                child: Column(
                  children: [
                    Text(
                      receipt.total.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.indigo.shade700),
                    ),
                    const Text("GHS",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                          color: Colors.indigo,
                        )),
                  ],
                ),
              ),
              // section for vendor name, tags, payment method icon and
              // purchase date
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 10),
                      child: Text(
                        receipt.vendor_name,
                        style: kRegularText,
                      ),
                    ),
                    Icon(
                      Icons.credit_card,
                      size: 20,
                      color: Colors.blueGrey.shade700,
                    ),
                    Text(
                      DateFormat('yMMMMd')
                          .add_Hm()
                          .format(receipt.purchase_time),
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: Colors.blueGrey.shade700),
                    )
                  ],
                ),
              ),
              // icon to open product tab in view more page
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 0),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceiptScreen(receipt: receipt),
                  ),
                );
              },
              child: Icon(
                Icons.more_horiz_rounded,
                color: Colors.indigo.shade700,
                size: 30,
              ),
            ),
          ),
        )
      ],
    );
  }
}