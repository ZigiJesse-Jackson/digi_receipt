
class Product{
  final int _product_id;
  final String product_name;
  final int product_quantity;
  final double product_price;

  const Product(this._product_id, this.product_name, this.product_price,this.product_quantity);
  int get product_id => _product_id;

}