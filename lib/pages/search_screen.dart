import 'package:digi_receipt/contants/style_constants.dart';
import 'package:digi_receipt/models/receipt_model.dart';
import 'package:digi_receipt/pages/filter_page.dart';
import 'package:flutter/material.dart';
import '../models/receipt_manager.dart';
import '../widgets/receipt_card.dart';

class SearchPage extends StatefulWidget {
  final ReceiptManager receiptList;
  const SearchPage({Key? key, required this.receiptList}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String last_query = "";
  List<ReceiptModel> _queriedResults = [];
  List<ReceiptModel> _filteredResults = [];
  TextEditingController controller = TextEditingController();
  bool toggleIconButton = true;
  bool filter_applied = false;
  void clearResults() {
    setState(() {
      _queriedResults = [];
    });
  }
  /// clear filters and "unfilter" results
  void clearFilter() {
    setState(() {
      _filteredResults = [];
      filter_applied = false;
      _queriedResults =
          ReceiptManager.searchReceipt(widget.receiptList.receipts, last_query);
    });
  }
  /// set filters on receipt total and purchase date and get results with filters
  /// applied
  void filter(double? min, double? max, DateTime? begin, DateTime? end) {
    setState(() {
      _filteredResults = ReceiptManager.receiptTotalInRange(
          widget.receiptList.receipts, min, max);
      _filteredResults =
          ReceiptManager.receiptsInDateRange(_filteredResults, begin, end);
      if (!filter_applied) filter_applied = true;

      getResults();
    });
  }

  /// retrieve receipts based on search query and filters if applied
  void getResults() {
    setState(() {
      // if (controller.text.isEmpty) {
      //   clearResults();
      //   return;
      // }
      if (filter_applied == true) {
        _queriedResults =
            ReceiptManager.searchReceipt(_filteredResults, controller.text);
      } else {
        _queriedResults = ReceiptManager.searchReceipt(
            widget.receiptList.receipts, controller.text);
      }
      last_query = controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    suffixIcon: controller.text.isEmpty
                        ? const Icon(Icons.search)
                        : IconButton(
                        onPressed: () {
                          controller.clear();
                          toggleIconButton = true;
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear)),
                    label: Text(
                      "Search For Receipt",
                      style: kRegularText,
                    ),
                  ),
                  onChanged: (text) {
                    if (controller.text.isNotEmpty && toggleIconButton) {
                      setState(() {
                        toggleIconButton = false;
                      });
                    }
                  },
                  onSubmitted: (value) {
                    setState(() {
                      getResults();
                    });
                  },
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilterPage(
                      filter: filter,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.tune_outlined,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        filter_applied
            ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Clear Filters"),
              GestureDetector(
                onTap: () {
                  clearFilter();
                },
                child: const Icon(
                  Icons.cancel_rounded,
                  color: Colors.red,
                ),
              )
            ],
          ),
        )
            : const SizedBox(
          height: 25,
        ),
        Container(
          child: _queriedResults.isEmpty
              ? const SizedBox()
              : Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 10),
                  child: ReceiptCard(receipt: _queriedResults[index]),
                );
              },
              itemCount: _queriedResults.length,
            ),
          ),
        )
      ],
    );
  }
}