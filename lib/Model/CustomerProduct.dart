class CustomerProduct {
  String id;
  String productName;
  double unitPurchased;
  double unitPrice;
  String unitName;
  double total;
  DateTime date;
  CustomerProduct(
      {this.id,
      this.productName,
      this.total: 0,
      this.unitPrice,
      this.unitPurchased,
      this.unitName,
      this.date});
}
