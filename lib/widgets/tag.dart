import 'package:digi_receipt/services/random_color_generator_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:from_css_color/from_css_color.dart';


class Tag extends StatelessWidget {
  final String tag_name;
  final Function onDeleted;


  Tag({
    Key? key,
    required this.tag_name,
    required this.onDeleted
  }) : super(key: key);

  final color = fromCssColor(RandomColor.getColor(options));

  Widget _buildChip(String label, Color color) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.white70,
        child: Text(label[0].toUpperCase()),
      ),
      deleteIcon: Icon(Icons.remove_circle_outline_sharp),
      deleteIconColor: Colors.white70,
      deleteButtonTooltipMessage: "Remove tag",
      onDeleted: ()async{
          await onDeleted(label);
      },
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),

      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );

}

  @override
  Widget build(BuildContext context) {

    return _buildChip(tag_name, color);
  }
}