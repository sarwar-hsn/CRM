import 'package:flutter/foundation.dart';
import '../Model/Customer.dart';

class Customers with ChangeNotifier {
  List<Customer> _customers = [
    Customer(
      id: DateTime.now().toString(),
      name: 'abdul',
      date: DateTime.now(),
      mobile: '01736524187',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString() + '1',
      name: 'mojid',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString(),
      name: 'adf',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString() + '2',
      name: 'sdf',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString() + '3',
      name: 'fda',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString(),
      name: 'wer',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString() + '12',
      name: 'erwe',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString(),
      name: 'rewer',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString(),
      name: 'wqqq',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString(),
      name: 'yyr',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString(),
      name: 'ryt',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: DateTime.now().toString(),
      name: 'rtewrt',
      date: DateTime.now(),
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
