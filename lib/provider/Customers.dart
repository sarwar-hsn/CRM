import 'package:flutter/foundation.dart';
import 'package:manage/Model/CustomerProduct.dart';
import 'package:manage/Model/PurchasedDate.dart';
import '../Model/Customer.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class Customers with ChangeNotifier {
  List<Customer> _customers = [
    Customer(
      id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.google.com'),
      name: 'Abdul',
      mobile: '01736524187',
      total: 1000,
      paid: 300,
      due: 700,
      address: 'birampur',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.facebook.com'),
      name: 'Hamid',
      mobile: '0173658967',
      total: 10000,
      paid: 3000,
      due: 7000,
      address: 'Hili',
      schedulePay: DateTime.now(),
    ),
  ];

  void customerByName() {
    _customers.sort((a, b) => a.name.compareTo(b.name));
  }

  List<Customer> get customers {
    return [..._customers];
  }

  Customer getCustomerById(String id) {
    for (int i = 0; i < _customers.length; i++) {
      if (_customers[i].id == id) return _customers[i];
    }
    return null;
  }

  void callListner() {
    notifyListeners();
  }

  void addCustomer(Customer newCustomer) {
    _customers.add(newCustomer);
  }
}
