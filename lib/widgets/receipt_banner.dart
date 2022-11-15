import 'package:digi_receipt/contants/style_constants.dart'
    show kCompanyInfoStyle, kCompanyNameStyle;
import 'package:flutter/material.dart';

class ReceiptBanner extends StatelessWidget {
  final String vendor_name;
  final String vendor_location;
  final String vendor_number;
  final String vendor_mail;
  const ReceiptBanner({
    Key? key,
    required this.vendor_name,
    this.vendor_location = "",
    this.vendor_mail = "",
    this.vendor_number = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black38,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              const Text(
                "Digi-Receipts",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 35,
                  letterSpacing: 2,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              vendor_name,
                              style: kCompanyNameStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            vendor_location,
                            style: kCompanyInfoStyle,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            vendor_number,
                            style: kCompanyInfoStyle,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            vendor_mail,
                            style: kCompanyInfoStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}