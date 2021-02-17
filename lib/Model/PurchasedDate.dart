import 'package:json_annotation/json_annotation.dart';
import 'package:manage/Model/CustomerProduct.dart';

part 'PurchasedDate.g.dart';

@JsonSerializable(explicitToJson: true)
class PurchasedDate {
  String date;
  List<CustomerProduct> products;
  PurchasedDate({this.date, this.products});
  factory PurchasedDate.fromJson(Map<String, dynamic> data) =>
      _$PurchasedDateFromJson(data);
  Map<String, dynamic> toJson() => _$PurchasedDateToJson(this);
}
