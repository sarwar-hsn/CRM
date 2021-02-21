import 'package:flutter/material.dart';

import '../../Model/Customer.dart';
import '../../provider/Customers.dart';
import '../Customer/customerDetailScreen.dart';

class SearchByName extends SearchDelegate<String> {
  final List<Customer> customers;
  SearchByName({this.customers});
  //Customers customersObj = new Customers();
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
    for (int i = 0; i < customers.length; i++) {
      if (customers[i].name == name) return customers[i].id;
    }
    return null;
  }

  Customer getCustomerById(String id) {
    for (int i = 0; i < customers.length; i++) {
      if (customers[i].id == id) return customers[i];
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
