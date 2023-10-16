import 'package:digi_receipt/pages/home_page.dart';
import 'package:digi_receipt/pages/search_screen.dart';
import 'package:digi_receipt/pages/testpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digi_receipt/pages/save_receipt.dart';

import 'models/receipt_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
      create: (context) => ReceiptManager(), child: const ReceiptHomeScreen()));
}

class ReceiptHomeScreen extends StatefulWidget {
  const ReceiptHomeScreen({Key? key}) : super(key: key);

  @override
  State<ReceiptHomeScreen> createState() => _ReceiptHomeScreenState();
}

class _ReceiptHomeScreenState extends State<ReceiptHomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const MainBody(),
    Consumer(builder: (context, ReceiptManager rList, child) {
      return SearchPage(receiptList: rList);
    }),
    Consumer(
      builder: (context, ReceiptManager rManager, child) => CapturePage(
        rMgr: rManager,
      ),
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Nunito', primaryColor: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("Digi-Receipt"),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined),
              label: 'Camera',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.indigo.shade800,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}