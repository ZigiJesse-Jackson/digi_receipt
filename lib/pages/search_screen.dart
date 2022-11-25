import 'package:digi_receipt/models/receipt_manager.dart';
import 'package:digi_receipt/models/receipt_model.dart';
import 'package:digi_receipt/widgets/receipt_display.dart';
import 'package:flutter/material.dart';

class CustomSearchReceiptClass extends SearchDelegate {
  final ReceiptManager receiptMgr;
  List<ReceiptModel> searchResult = [];


  CustomSearchReceiptClass({required this.receiptMgr});

  @override
  List<Widget> buildActions(BuildContext context) {
// this will show clear query button
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
// adding a back button to close the search
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
//clear the old search list
    searchResult.clear();

//find the elements that starts with the same query letters if query is not empty.
    if(query.isEmpty) {
      searchResult = [];
    } else {
      print(query);
      searchResult = receiptMgr.searchReceipt(query);
    }

// view a list view with the search result
    return Container(
      margin: const EdgeInsets.all(20),
      child: searchResult.isNotEmpty? ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          scrollDirection: Axis.vertical,
          children: List.generate(searchResult.length, (index) {
            return ReceiptDisplay(
              receipt: searchResult[index],
            );
          })):Center(child: Text("No results found"),),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
// I will add this step as an optional step later
    return Container();
  }
}