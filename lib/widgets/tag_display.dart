import 'package:digi_receipt/contants/style_constants.dart' show kTotalStyle;
import 'package:digi_receipt/widgets/tag.dart';
import 'package:flutter/material.dart';

class TagsDisplay extends StatefulWidget {
  List<String> tags;
  Function onDelete;
  TagsDisplay({
    Key? key,
    required this.tags,
    required this.onDelete
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

        Text(widget.tags.isEmpty?"":"Tags", style: kTotalStyle,),
        const SizedBox(width: 25,),
        Expanded(
          child: SizedBox(
            height: 35,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [for(String tagName in widget.tags) Tag(tag_name: tagName, onDeleted: widget.onDelete,)],
            ),
          ),
        )
      ],
    );
  }
}