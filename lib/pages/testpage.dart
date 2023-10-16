import 'dart:async';
import 'dart:convert';
import 'package:digi_receipt/services/receipt_checkers.dart';
import 'package:digi_receipt/pages/save_receipt.dart';
import 'package:flash/flash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/receipt_manager.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CapturePage extends StatefulWidget {
  ReceiptManager rMgr;
  CapturePage({Key? key, required this.rMgr}) : super(key: key);

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {

  void showAlert(){
    context.showFlashDialog(
        content: Text("QR-Code does not contain receipt"),
      negativeActionBuilder: (context, controller, _) {
        return TextButton(
          onPressed: () {
            controller.dismiss();
          },
          child: Text('Exit'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return MobileScanner(
      fit: BoxFit.contain,
      controller: MobileScannerController(),
      onDetect: (capture) async {
        final List<Barcode> barcodes = capture.barcodes;
        String val = '';
        final completer = Completer();

        for (final barcode in barcodes) {

          val += barcode.rawValue!;
        }
        Future.delayed(const Duration(seconds: 3)).then((_) => completer.complete());

        Map<String, Object?> possMap = jsonDecode(val);

        if (checkReceipt(possMap)) {
          context.showBlockDialog(dismissCompleter: completer);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SavePage(rMgr: widget.rMgr, scanned_receipt: possMap),
            ),
          );
        } else{
          showAlert();
          context.showBlockDialog(dismissCompleter: completer);
        }
      },
    );
  }
}