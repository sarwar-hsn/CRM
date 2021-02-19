import 'package:json_annotation/json_annotation.dart';
import 'package:manage/Model/PurchasedDate.dart';
part 'Customer.g.dart';

@JsonSerializable(explicitToJson: true)
class Customer {
  String id;
  String name;
  String mobile;
  double total;
  double paid;
  double due;
  String address;
  List<Map<String, Object>> paymentDate;
  String schedulePay;
  List<PurchasedDate> products;
  Customer({
    this.id,
    this.name,
    this.mobile,
    this.paid: 0,
    this.address,
    this.schedulePay,
    this.due: 0,
    this.total: 0,
    this.paymentDate,
    this.products,
  });

  factory Customer.fromJson(Map<String, dynamic> data) =>
      _$CustomerFromJson(data);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
