import 'package:manage/Model/CustomerProduct.dart';

class Customer {
  String id;
  String name;
  String mobile;
  double total;
  double paid;
  double due;
  String address;
  DateTime schedulePay;
  List<CustomerProduct> products;
  Customer(
      {this.id,
      this.name,
      this.mobile,
      this.paid,
      this.address,
      this.schedulePay,
      this.products,
      this.due,
      this.total});
}
