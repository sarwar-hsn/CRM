import './Customer.dart';
import './Product.dart';

List<Customer> customers = [
  Customer(
      id: DateTime.now().toString(),
      name: 'abdul',
      date: DateTime.now(),
      mobile: '01736524187',
      schedulePay: DateTime.now(),
      products: [products[0], products[1]]),
  Customer(
      id: DateTime.now().toString(),
      name: 'mojid',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
      products: [products[0], products[1]]),
  Customer(
      id: DateTime.now().toString(),
      name: 'adf',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
      products: [products[0], products[1]]),
  Customer(
      id: DateTime.now().toString(),
      name: 'sdf',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
      products: [products[0], products[1]]),
  Customer(
      id: DateTime.now().toString(),
      name: 'fda',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
      products: [products[0], products[1]]),
  Customer(
      id: DateTime.now().toString(),
      name: 'wer',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
      products: [products[0], products[1]]),
  Customer(
      id: DateTime.now().toString(),
      name: 'erwe',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
      products: [products[0], products[1]]),
  Customer(
      id: DateTime.now().toString(),
      name: 'rewer',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
      products: [products[0], products[1]]),
  Customer(
      id: DateTime.now().toString(),
      name: 'wqqq',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
      products: [products[0], products[1]]),
  Customer(
      id: DateTime.now().toString(),
      name: 'yyr',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
      products: [products[0], products[1]]),
  Customer(
      id: DateTime.now().toString(),
      name: 'ryt',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
      products: [products[0], products[1]]),
  Customer(
      id: DateTime.now().toString(),
      name: 'rtewrt',
      date: DateTime.now(),
      mobile: '017*******',
      schedulePay: DateTime.now(),
      products: [products[0], products[1]]),
];

List<Customer> customerByName() {
  customers.sort((a, b) => a.name.compareTo(b.name));
  return customers;
}

List<Product> products = [
  Product(name: 'rod', unitName: 'kg', unitPrice: 200, unitPurchased: 10),
  Product(name: 'cement', unitName: 'kg', unitPrice: 50, unitPurchased: 10)
];
