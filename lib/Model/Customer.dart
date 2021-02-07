import 'package:manage/Model/CustomerProduct.dart';
import 'package:manage/Model/PurchasedDate.dart';

class Customer {
  String id;
  String name;
  String mobile;
  double total;
  double paid;
  double due;
  String address;
  DateTime schedulePay;
  List<PurchasedDate> products = [];
  Customer(
      {this.id,
      this.name,
      this.mobile,
      this.paid,
      this.address,
      this.schedulePay,
      this.due,
      this.total,
      this.products});
}
