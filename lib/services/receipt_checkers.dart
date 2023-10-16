
int getInt(Object? possInt) {
  if (possInt != null) return possInt as int;
  return 0;
}

double getDouble(Object? possDouble) {
  if (possDouble != null) return possDouble as double;
  return 0;
}

String getString(Object? possString) {
  if (possString != null) return possString as String;
  return "";
}

String getProductsAsString(Object? possMap) {
  if (possMap != null && possMap is List) {
    String productString = "";
    for (var pMap in possMap) {
      String singleProd = "";
      var total = getInt(pMap['quantity']) * pMap['product_price'];
      singleProd += pMap['product_name'] +
          "  x${getInt(pMap['quantity']).toString()} "
              "${total.toString()}" +
          "\n\n";
      productString += singleProd;
    }
    return productString;
  }
  return "";
}

bool checkReceipt(Object? possReceipt) {
  if (possReceipt == null || possReceipt is! Map<String, Object?>)
    return false;
  // checking that map contains relevant keys for receipt
  if (possReceipt.containsKey('vendor') &&
      possReceipt.containsKey('location') &&
      possReceipt.containsKey('phone') &&
      possReceipt.containsKey('time') &&
      possReceipt.containsKey('total_price') &&
      possReceipt.containsKey('products')) return true;

  return false;
}