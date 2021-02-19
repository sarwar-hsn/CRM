import 'package:json_annotation/json_annotation.dart';
part 'Product.g.dart';

@JsonSerializable()
class Product {
  String id;
  String name;
  double unitPrice;
  String unitName;
  double availableAmount;
  String category;
  Product(
      {this.id,
      this.name,
      this.unitPrice,
      this.unitName,
      this.availableAmount,
      this.category});

  factory Product.fromJson(Map<String, dynamic> data) =>
      _$ProductFromJson(data);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
