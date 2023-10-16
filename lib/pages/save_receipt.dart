import 'package:digi_receipt/services/receipt_checkers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../contants/service_constants.dart';
import '../models/receipt_manager.dart';

class SavePage extends StatefulWidget {
  ReceiptManager rMgr;
  final Map<String, Object?> scanned_receipt;

  SavePage({Key? key, required this.rMgr, required this.scanned_receipt})
      : super(key: key);

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Text(
                          "RECEIPT SUCCESSFULLY READ!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Open Sans',
                          ),
                        ),
                      ],
                    ),
                  ),
                  DetailReceiptRow(
                    rowKey: "Vendor",
                    rowValue: getString(widget.scanned_receipt['vendor']),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DetailReceiptRow(
                    rowKey: "Location",
                    rowValue: getString(widget.scanned_receipt['location']),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DetailReceiptRow(
                    rowKey: "Products",
                    rowValue:
                        getProductsAsString(widget.scanned_receipt['products']),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DetailReceiptRow(
                    rowKey: "Total",
                    rowValue: "GHS " +
                        widget.scanned_receipt['total_price'].toString(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DetailReceiptRow(
                    rowKey: "Date",
                    rowValue: DateFormat('yMMMMd').add_Hm().format(
                        DateTime.fromMillisecondsSinceEpoch(
                            getInt(widget.scanned_receipt['time']) * 1000)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                OutlinedButton(
                  onPressed: () async {
                    await widget.rMgr.insert_Receipt(
                        await getDBPath(), widget.scanned_receipt);
                    setState(() {});
                  },
                  child: const Text("Save"),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}

class DetailReceiptRow extends StatelessWidget {
  const DetailReceiptRow(
      {Key? key, required this.rowKey, required this.rowValue})
      : super(key: key);

  final String rowKey;
  final String rowValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            rowKey,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            width: 50,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  rowValue,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}