import 'package:digi_receipt/widgets/number_input_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FilterPage extends StatefulWidget {
  FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  TextEditingController _minPriceController = TextEditingController();

  TextEditingController _maxPriceController = TextEditingController();

  void setVal() {
    setState(() {});
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    print('${DateFormat('dd/MM/yyyy').format(args.value.startDate)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Filters"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
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
                            label: 'Max Total',
                            controller: _maxPriceController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text("Min price picked: GHS ${_minPriceController.text}"),
                  Text("Max price picked: GHS"),
                ],
              ),
              Text(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45,vertical: 0),
                child: MaterialButton(onPressed: () {  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
              )
            ],
          ),

        ),

      ),
    );
  }
}