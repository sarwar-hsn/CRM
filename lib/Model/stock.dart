class Stock {
  String id;
  String companyName;
  String productName;
  double totalUnit;
  double unitPrice;
  double totalCost;
  double paid;
  double due;
  double extraFee;
  DateTime date;
  List<Map<String, Object>> paymentHistory = [];
  Stock(
      {this.date,
      this.companyName,
      this.id,
      this.due: 0,
      this.paid: 0,
      this.paymentHistory,
      this.productName: '___',
      this.totalCost: 0,
      this.totalUnit: 0,
      this.extraFee: 0,
      this.unitPrice: 0});
}
