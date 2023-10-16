import 'package:digi_receipt/contants/style_constants.dart';
import 'package:digi_receipt/widgets/number_input_field.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:intl/intl.dart';

class FilterPage extends StatefulWidget {
  final Function filter;
  const FilterPage({Key? key, required this.filter}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  // filter properties
  double? _min;
  double? _max;
  bool selected_begin = false;
  DateTime? _begin_date;
  DateTime? _end_date;

  void setDate(selectedDate, dateToChange) {
    setState(() {
      dateToChange = selectedDate;
    });
  }

  Future<DateTime?> _selectDate(BuildContext context, DateTime initialDate,
      DateTime firstDate, DateTime lastDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate);
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Price Filter",
                    style: kBigText,
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                        child: NumberInput(
                            label: "Min Price",
                            controller: _minPriceController,
                            onChanged: () {
                              _min = double.tryParse(_minPriceController.text);
                            })),
                    const Icon(Icons.minimize),
                    Flexible(
                        child: NumberInput(
                            label: "Max Price",
                            controller: _maxPriceController,
                            onChanged: () {
                              _max = double.tryParse(_maxPriceController.text);
                            }))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "Date Filter",
                    style: kBigText,
                  ),
                ),
                _begin_date == null
                    ? OutlinedButton(
                        onPressed: () async {
                          _begin_date = await _selectDate(
                              context,
                              DateTime.now(),
                              DateTime(2000),
                              _end_date ?? DateTime(2100));
                          setState(() {
                            _begin_date;
                          });
                        },
                        child: Text(
                          "From",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "From: ${DateFormat('yMMMMd').format(_begin_date!)}",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _begin_date = null;
                                });
                              },
                              icon: Icon(Icons.clear))
                        ],
                      ),
                _end_date == null
                    ? OutlinedButton(
                        onPressed: () async {
                          _end_date = await _selectDate(
                              context,
                              _begin_date ?? DateTime.now(),
                              _begin_date ?? DateTime(2000),
                              DateTime(2100));
                          setState(() {
                            _end_date;
                          });
                        },
                        child: Text(
                          "To",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "To: ${DateFormat('yMMMMd').format(_end_date!)}",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _end_date = null;
                                });
                              },
                              icon: Icon(Icons.clear))
                        ],
                      ),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "CANCEL",
                            style: kBigTextButton,
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red)),
                      SizedBox(
                        width: 50,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          widget.filter(_min, _max, _begin_date, _end_date);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "APPLY",
                          style: kBigTextButton,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}