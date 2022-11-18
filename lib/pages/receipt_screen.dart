import 'package:digi_receipt/widgets/receipt_banner.dart';
import 'package:digi_receipt/contants/style_constants.dart';
import 'package:digi_receipt/widgets/receipt_tile.dart';
import 'package:digi_receipt/widgets/total_display.dart';
import 'package:digi_receipt/widgets/tag_display.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../models/receipt_model.dart';

class ReceiptScreen extends StatefulWidget {
  ReceiptModel receipt;

  ReceiptScreen({Key? key, required this.receipt}) : super(key: key);

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  String codeDialog = "";
  String valueText = "";

  final TextEditingController _textFieldController = TextEditingController();

  /// get receipt items total
  double getTotal() => widget.receipt.items.fold(
      0,
      (productTotal, curr) =>
          (curr.product_quantity * curr.product_price) + productTotal);

  Future<void> _deleteTag(String tagName)async{
    await widget.receipt.removeTag(tagName);
    setState(() {});
  }
  // function to display dialog box for user input of tag to add
  Future<void> _addTagAlertDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('RECEIPT TAG NAME'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Input tag name"),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.lightBlueAccent,
                textColor: Colors.white,
                child: Text('ADD TAG'),
                onPressed: () async {
                  if (valueText.trim().isEmpty) {
                    context.showErrorBar(
                        content: Text("Tag name must not be empty"));
                  } else {
                    codeDialog = valueText.trim();
                    bool inserted = await widget.receipt.addTag(codeDialog);
                    if (inserted) {
                      setState(() {
                        _textFieldController.clear();
                        context.showSuccessBar(
                            content: Text("Tag name successfully added!"));
                      });
                      Navigator.pop(context);
                    } else
                      context.showErrorBar(
                          content: Text("Tag name already added!"));
                  }
                },
              ),
            ],
          );
        });
  }

  void _showDialogFlash({bool persistent = true}) {
    context.showFlashDialog(
        constraints: BoxConstraints(maxWidth: 300),
        persistent: persistent,
        title: Text('Flash Dialog'),
        content: Text(
            'Do you want to remove all tags?'),
        negativeActionBuilder: (context, controller, _) {
          return TextButton(
            onPressed: () {
              controller.dismiss();
            },
            child: Text('NO'),
          );
        },
        positiveActionBuilder: (context, controller, _) {
          return TextButton(
              onPressed: () async{
                await widget.receipt.removeAllTags();
                setState(() {});
                context.showSuccessBar(content: Text('All tags removed'));
                controller.dismiss();
              },
              child: Text('YES'));
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Nunito'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ReceiptBanner(
                  vendor_name: widget.receipt.vendor_name,
                  vendor_location: widget.receipt.vendor_address,
                  vendor_number: widget.receipt.vendor_phone,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                  child: TotalDisplay(
                    total_price: widget.receipt.total,
                  ),
                ),
                TagsDisplay(
                  tags: widget.receipt.tags,
                  onDelete: _deleteTag,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        _addTagAlertDialog(context);
                      },
                      minWidth: 20,
                      child: const Text(
                        "Add Tag",
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    widget.receipt.tags.isNotEmpty
                        ? MaterialButton(onPressed: () async{

                          _showDialogFlash();
                    },minWidth: 20,child: const Icon(Icons.delete_forever, color: Colors.blueGrey,),)
                        : const SizedBox(),
                  ],
                ),
                const Divider(
                  height: 5,
                  thickness: 3,
                ),
                Flexible(
                  child: ListView(
                    children: [
                      for (Product p in widget.receipt.items)
                        ReceiptItemTile(
                            item_name: p.product_name,
                            price: p.product_price,
                            quantity: p.product_quantity)
                    ],
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
                            "${(widget.receipt.total - getTotal()).toStringAsFixed(2)} GHS",
                            style: kSubInfoStyle,
                          ),
                          Text("${widget.receipt.total.toStringAsFixed(2)} GHS",
                              style: kTotalStyle),
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
                          "*Purchased on ${DateFormat('yMMMMd').add_Hm().format(widget.receipt.purchase_time)}",
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