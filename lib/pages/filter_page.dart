import 'package:digi_receipt/models/receipt_manager.dart';
import 'package:digi_receipt/models/receipt_model.dart';
import 'package:digi_receipt/widgets/number_input_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../widgets/receipt_display.dart';

class FilterPage extends StatefulWidget {
  final receipts;
  const FilterPage({Key? key, required this.receipts}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _searchQueryController = TextEditingController();
  // filter properties
  DateTime? _begin_date;
  double? _min;
  double? _max;
  DateTime? _end_date;
  List<ReceiptModel> filtered = [];
  String? _searchQuery;
  DateTime? get begin_date => _begin_date;

  set begin_date(DateTime? beginDate) {
    _begin_date = beginDate;
  }

  DateTime? get end_date => _end_date;

  set end_date(DateTime? endDate) {
    _end_date = endDate;
  }

  void setVal() {
    setState(() {});
  }

  void filter(){
    setState(() {
      filtered.clear();
      filtered = widget.receipts;
      // getting text input values if any
      if(_minPriceController.text.isNotEmpty)_min = double.parse(_minPriceController.text);
      if(_maxPriceController.text.isNotEmpty)_max = double.parse(_maxPriceController.text);
      if(_searchQueryController.text.isNotEmpty) {
        _searchQuery = _searchQueryController.text;

      }

      // filtering by query
      filtered = ReceiptManager.searchReceipt(filtered, _searchQueryController.text);
      // filtering by total range
      filtered = ReceiptManager.receiptTotalInRange(filtered, _min, _max);
      // filtering by date range
      filtered = ReceiptManager.receiptsInDateRange(filtered, _begin_date, _end_date);

      _minPriceController.clear();
      _maxPriceController.clear();
      _searchQueryController.clear();

    });

  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    begin_date = args.value.startDate;
    end_date = args.value.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Filters"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Receipt Total Range",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 16.0),
                            child: NumberInput(
                              label: 'Min Total',
                              controller: _minPriceController,
                              onChanged: setVal,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: NumberInput(
                              onChanged: setVal,
                              label: 'Max Total',
                              controller: _maxPriceController,
                            ),
                          ),
                        ),
                      ],
                    ),
                   ],
                ),
                const Text(
                  "Purchase Date Range",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16.0),
                        child: TextField(
                          controller: _searchQueryController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Center(child: Text("Search term")),),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45,vertical: 0),
                  child: MaterialButton(onPressed: () {

                    filter();
                  },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.filter_list_rounded),
                        Text("Filter Receipts",
                         style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        )
                      ],
                    ),

                  ),
                ),
                filtered.isEmpty? Row(): Container(
                  height: 500,
                  margin: EdgeInsets.all(20),
                  child: ListView(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      children: List.generate(filtered.length, (index) {
                        return ReceiptDisplay(
                          receipt: filtered[index],
                        );
                      })),
                )
              ],
            ),

          ),
        ),

      ),
    );
  }
}