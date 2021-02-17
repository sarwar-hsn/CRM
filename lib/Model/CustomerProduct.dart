import 'package:json_annotation/json_annotation.dart';

part 'CustomerProduct.g.dart';

@JsonSerializable()
class CustomerProduct {
  String id;
  String productName;
  double unitPurchased;
  double unitPrice;
  String unitName;
  double total;

  CustomerProduct({
    this.id,
    this.productName,
    this.total: 0,
    this.unitPrice,
    this.unitPurchased,
    this.unitName,
  });
  factory CustomerProduct.fromJson(Map<String, dynamic> data) =>
      _$CustomerProductFromJson(data);
  Map<String, dynamic> toJson() => _$CustomerProductToJson(this);
}
