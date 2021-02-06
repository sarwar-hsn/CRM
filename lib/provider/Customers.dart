import 'package:flutter/foundation.dart';
import '../Model/Customer.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class Customers with ChangeNotifier {
  List<Customer> _customers = [
    Customer(
      id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.google.com'),
      name: 'abdul',
      mobile: '01736524187',
      total: 1000,
      paid: 300,
      due: 700,
      address: 'birampur',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.google.com'),
      name: 'mojid',
      mobile: '01763897425',
      total: 25000,
      paid: 5000,
      due: 20000,
      address: 'Hakimpur',
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.google.com'),
      name: 'jabir',
      mobile: '01731251478',
      total: 360,
      paid: 360,
      due: 0,
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.google.com'),
      name: 'sefa',
      mobile: '01789632541',
      total: 5000,
      paid: 4000,
      due: 1000,
      schedulePay: DateTime.now(),
    ),
    Customer(
      id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.google.com'),
      name: 'fatih',
      mobile: '01745654565',
      total: 1500,
      paid: 300,
      due: 1200,
      schedulePay: DateTime.now(),
    ),
  ];

  void customerByName() {
    _customers.sort((a, b) => a.name.compareTo(b.name));
  }

  List<Customer> get customers {
    return [..._customers];
  }

  void addCustomer(Customer newCustomer) {
    _customers.add(newCustomer);
  }
}
