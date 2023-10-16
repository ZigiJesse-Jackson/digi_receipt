import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/receipt_manager.dart';
import '../widgets/receipt_card.dart';

class MainBody extends StatelessWidget {
  const MainBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Consumer(builder: (context, ReceiptManager rManager, child) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: ReceiptCard(receipt: rManager.receipts[index]),
                );
              },
              itemCount: rManager.length,
            );
          }),
        ),
      ],
    );
  }
}