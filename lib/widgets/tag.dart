import 'package:digi_receipt/contants/style_constants.dart' show kTagStyle;
import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String tag_name;
  const Tag({
    Key? key,
    required this.tag_name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(tag_name, style: kTagStyle,),
        ),
      ),
    );
  }
}