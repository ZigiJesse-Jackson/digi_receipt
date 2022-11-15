import 'package:digi_receipt/contants/style_constants.dart' show kTotalDisplay;
import 'package:flutter/material.dart';

class TotalDisplay extends StatelessWidget {
  final double total_price;
  const TotalDisplay({
    Key? key,
    required this.total_price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "${total_price.toStringAsFixed(2)} GHS",
    style: kTotalDisplay,);
  }
}