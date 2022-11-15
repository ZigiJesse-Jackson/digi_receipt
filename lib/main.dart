import 'package:digi_receipt/models/receipt_manager.dart';
import 'package:digi_receipt/widgets/receipt_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ReceiptHomeScreen());
}

class ReceiptHomeScreen extends StatefulWidget {
  const ReceiptHomeScreen({Key? key}) : super(key: key);

  @override
  State<ReceiptHomeScreen> createState() => _ReceiptHomeScreenState();
}

class _ReceiptHomeScreenState extends State<ReceiptHomeScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReceiptManager>(
      create: (context)=> ReceiptManager(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Welcome to Digi-Receipts",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            letterSpacing: 1.2),
                      ),
                      SizedBox(
                        child: Text(
                          "View your receipts below",
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                      Divider(
                        thickness: 3,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer(
                      builder: (context, ReceiptManager rManager, child) {
                        return ListView.builder(itemBuilder: (context, index){
                          return ReceiptDisplay(
                          receipt: rManager.receipts[index]);
                        },
                        itemCount: rManager.length,);

                      }),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}