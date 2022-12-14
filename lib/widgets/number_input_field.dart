import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberInput extends StatelessWidget {
  NumberInput({
    required this.label,
    this.controller,
    this.value,
    required this.onChanged,
    this.error,
    this.icon,
    this.allowDecimal = true,
  });

  final TextEditingController? controller;
  final String? value;
  final String label;
  final Function onChanged;
  final String? error;
  final Widget? icon;
  final bool allowDecimal;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: value,
      onChanged: (String val){
        onChanged();
      },
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(_getRegexString())),
        TextInputFormatter.withFunction(
              (oldValue, newValue) => newValue.copyWith(
            text: newValue.text,
          ),
        ),
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: Center(child: Text(label)),
        errorText: error,
        icon: icon,
      ),
    );
  }

  String _getRegexString() =>
      allowDecimal ? r'[0-9]+[,.]{0,1}[0-9]{0,2}' : r'[0-9]';
}