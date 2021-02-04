import 'package:flutter/foundation.dart';
import '../Model/Customer.dart';

class Customers with ChangeNotifier {
  List<Customer> _customers = [
    Customer(
      id: DateTime.now().toString(),
      name: 'abdul',
      mobile: '01736524187',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString() + '1',
      name: 'mojid',
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString(),
      name: 'adf',
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString() + '2',
      name: 'sdf',
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString() + '3',
      name: 'fda',
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString(),
      name: 'wer',
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString() + '12',
      name: 'erwe',
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString(),
      name: 'rewer',
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString(),
      name: 'wqqq',
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString(),
      name: 'yyr',
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString(),
      name: 'ryt',
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString(),
      name: 'rtewrt',
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
  ];

  void customerByName() {
    _customers.sort((a, b) => a.name.compareTo(b.name));
  }

  List<Customer> get customers {
    return [..._customers];
  }
}
