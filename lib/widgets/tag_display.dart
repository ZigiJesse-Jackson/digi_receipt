import 'package:digi_receipt/contants/style_constants.dart' show kTotalStyle;
import 'package:digi_receipt/widgets/tag.dart';
import 'package:flutter/material.dart';

class TagsDisplay extends StatefulWidget {
  List<String> tags;
  TagsDisplay({
    Key? key,
    required this.tags,
  }) : super(key: key);

  @override
  State<TagsDisplay> createState() => _TagsDisplayState();
}

class _TagsDisplayState extends State<TagsDisplay> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Text(widget.tags.length == 0?"":"Tags", style: kTotalStyle,),
        const SizedBox(width: 25,),
        Expanded(
          child: Container(
            height: 23,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [for(String tag_name in widget.tags) Tag(tag_name: tag_name)],
            ),
          ),
        )
      ],
    );
  }
}