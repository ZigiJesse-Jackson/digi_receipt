import 'package:digi_receipt/models/receipt_manager.dart';
import 'package:digi_receipt/pages/filter_page.dart';
import 'package:digi_receipt/pages/search_screen.dart';
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
      create: (context) => ReceiptManager(),
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Nunito'),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
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
                    ],
                  ),
                ),
                const Divider(
                  thickness: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer(
                        builder: (context, ReceiptManager rManager, child) {
                      return IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FilterPage()));
                        },
                        icon: const Icon(
                          Icons.filter_list_rounded,
                          color: Colors.blueGrey,
                        ),
                      );
                    }),
                    Consumer(
                        builder: (context, ReceiptManager rManager, child) {
                      return IconButton(
                        onPressed: () {
                          showSearch(
                              context: context,
                              delegate: CustomSearchReceiptClass(
                                  receiptMgr: rManager));
                        },
                        icon: const Icon(
                          Icons.search_rounded,
                          color: Colors.blueGrey,
                        ),
                      );
                    }),
                  ],
                ),
                Expanded(
                  child: Consumer(
                      builder: (context, ReceiptManager rManager, child) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return ReceiptDisplay(
                            receipt: rManager.receipts[index]);
                      },
                      itemCount: rManager.length,
                    );
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