import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/Model/CustomerProduct.dart';
import 'package:manage/Model/PurchasedDate.dart';
import 'package:manage/Screens/Customer/customerDetailScreen.dart';
import '../Model/Customer.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:http/http.dart' as http;

class Customers extends SearchDelegate<String> with ChangeNotifier {
  List<Customer> _customers = [];

  void customerByName() {
    _customers.sort((a, b) => a.name.compareTo(b.name));
  }

  List<Customer> scheduledCustomer(DateTime date) {
    List<Customer> temp = [];
    for (int i = 0; i < _customers.length; i++) {
      if (_customers[i].schedulePay != null &&
          DateFormat('dd-MM-yyyy').format(date).toString() ==
              _customers[i].schedulePay.toString()) {
        temp.add(_customers[i]);
      }
    }
    return temp;
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

  Map<String, Object> getCustomerPaymentInfoByDate(String id, DateTime date) {
    double total = 0, paid = 0, due = 0;
    Customer customer = getCustomerById(id);
    for (int i = 0; i < customer.products.length; i++) {
      if (customer.products[i].date == DateFormat('dd-MM-yyyy').format(date)) {
        for (int j = 0; j < customer.products[i].products.length; j++) {
          total += customer.products[i].products[j].total;
        }
      }
    }
    for (int i = 0; i < customer.paymentDate.length; i++) {
      if (DateFormat('dd-MM-yyyy').format(date) ==
          DateFormat('dd-MM-yyyy').format(customer.paymentDate[i]['date'])) {
        paid += customer.paymentDate[i]['paid'];
      }
    }
    due = total - paid;
    return {
      'total': total,
      'paid': paid,
      'due': due,
    };
  }

  void callListner() {
    notifyListeners();
  }

  Future<void> addCustomer(Customer newCustomer) async {
    final url =
        'https://shohel-traders-default-rtdb.firebaseio.com/customers.json';
    try {
      var response = await http.post(url,
          body: json.encode({
            'name': newCustomer.name,
            'mobile': newCustomer.mobile,
            'total': newCustomer.total,
            'paid': newCustomer.paid,
            'due': newCustomer.due,
            'products': newCustomer.products,
            'schdulePay': newCustomer.schedulePay,
            'address': newCustomer.address,
            'paymentDate': newCustomer.paymentDate
          }));
      if (response.statusCode == 200) {
        newCustomer.id = jsonDecode(response.body)['name'];
        _customers.add(newCustomer);
        notifyListeners();
      } else
        throw Exception();
    } catch (e) {
      throw e;
    }
  }

  Future<void> editCustomer(Customer customer) async {
    var url =
        'https://shohel-traders-default-rtdb.firebaseio.com/customers/${customer.id}.json';
    try {
      var response = await http.patch(url,
          body: json.encode({
            'name': customer.name,
            'mobile': customer.mobile,
            'address': customer.address,
            'total': customer.total,
            'paid': customer.paid,
            'schedulePay': customer.schedulePay,
          }));
      if (response.statusCode != 200) throw Exception();
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<void> updateCustomerPayment(Customer customer) async {
    var url =
        'https://shohel-traders-default-rtdb.firebaseio.com/customers/${customer.id}.json';
    try {
      var response = await http.patch(url,
          body: json.encode({
            'due': customer.due,
            'paid': customer.paid,
            'paymentDate': customer.paymentDate,
          }));
      notifyListeners();
      if (response.statusCode != 200) throw response.statusCode;
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetCustomers() async {
    final url =
        'https://shohel-traders-default-rtdb.firebaseio.com/customers.json';
    try {
      var response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Customer> loadedCustomer = [];
      List<PurchasedDate> purchasedDate = [];
      extractedData.forEach((customerId, customerData) {
        Customer temp = Customer.fromJson(customerData);
        temp.id = customerId;
        loadedCustomer.add(temp);
      });

      _customers = loadedCustomer;
      notifyListeners();
    } catch (e) {
      print('Error' + e.toString());
    }
  }

  Future<void> addCustomerProduct(Customer customer) async {
    var url =
        'https://shohel-traders-default-rtdb.firebaseio.com/customers/${customer.id}.json';
    try {
      var response = await http.patch(url,
          body: json.encode({
            'paid': customer.paid,
            'total': customer.total,
            'due': customer.due,
            'products': customer.products,
            'paymentDate': customer.paymentDate
          }));

      if (response.statusCode != 200) throw response.statusCode;
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  List<Customer> recentSearch = [];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  String getCustomerIdByName(String name) {
    for (int i = 0; i < _customers.length; i++) {
      if (_customers[i].name == name) return _customers[i].id;
    }
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    String id = getCustomerIdByName(query);
    Customer customer = getCustomerById(id);
    return Center(
      child: Text('sorry not found'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSearch
        : customers.where((element) {
            return element.name.startsWith(query);
          }).toList();
    if (suggestionList.isEmpty) return Text('no search yet');
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            String id = getCustomerIdByName(suggestionList[index].name);
            Customer customer = getCustomerById(id);
            (customer == null)
                ? showResults(context)
                : Navigator.of(context).pushNamed(
                    CustomerDetailScreen.routeName,
                    arguments: customer.id);
          },
          leading: Icon(Icons.person),
          title: RichText(
              text: TextSpan(
                  text: suggestionList[index].name.substring(0, query.length),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                TextSpan(
                    text: suggestionList[index].name.substring(query.length))
              ])),
        );
      },
    );
  }
}
