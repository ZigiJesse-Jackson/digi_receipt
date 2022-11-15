import 'package:digi_receipt/contants/style_constants.dart' show kTotalStyle;
import 'package:digi_receipt/widgets/tag.dart';
import 'package:flutter/material.dart';

class TagsDisplay extends StatelessWidget {
  List<String> tags;
  TagsDisplay({
    Key? key,
    required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Text("Tags", style: kTotalStyle,),
        const SizedBox(width: 25,),
        Row(
          // creating tags in tag display
          children: [for(String tag_name in tags) Tag(tag_name: tag_name)],
        )
      ],
    );
  }
}