import 'package:manage/Model/CustomerProduct.dart';

class Customer {
  String id;
  String name;
  String mobile;
  DateTime date;
  double total;
  double paid;
  double due;
  DateTime schedulePay;
  List<CustomerProduct> products;
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
