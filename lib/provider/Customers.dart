import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manage/Model/CustomerProduct.dart';
import 'package:manage/Model/PurchasedDate.dart';
import 'package:manage/Screens/Customer/customerDetailScreen.dart';
import '../Model/Customer.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class Customers extends SearchDelegate<String> with ChangeNotifier {
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

  Map<String, Object> listofCustomerandTotalByDate(DateTime date) {
    List<Customer> temp = [];
    double total = 0;
    for (int i = 0; i < _customers.length; i++) {
      for (int j = 0; j < _customers[i].products.length; j++) {
        if (_customers[i].products[j].date == date) {
          for (int k = 0; k < _customers[i].products[j].products.length; k++) {
            total += _customers[i].products[j].products[k].total;
          }
          temp.add(_customers[i]);
        }
      }
    }
    return {'customers': temp, 'total': total};
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
