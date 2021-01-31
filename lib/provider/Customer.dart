import './Product.dart';

class Customer {
  String id;
  String name;
  String mobile;
  DateTime date;
  double total;
  double paid;
  double due;
  DateTime schedulePay;
  List<Product> products;
  double _calculateTotalPrice(List<Product> products) {
    double temp = 0;
    for (int i = 0; i < products.length; i++) {
      temp += products[i].totalAmount;
    }
    return temp;
  }

  Customer(
      {this.id,
      this.name,
      this.mobile,
      this.date,
      this.paid,
      this.schedulePay,
      this.products,
      this.due,
      this.total});
}
