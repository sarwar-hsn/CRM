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

  List<Customer> suggestionList;
  @override
  Widget buildResults(BuildContext context) {
    String id = getCustomerIdByName(query);
    Customer customer = getCustomerById(id);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blueGrey, Colors.white70])),
      child: Center(
          child: Container(
        height: MediaQuery.of(context).size.height * .7,
        width: MediaQuery.of(context).size.height * .7,
        child: ListView.builder(
          itemCount: suggestionList.length,
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.black12)),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            CustomerDetailScreen.routeName,
                            arguments: suggestionList[index].id);
                      },
                      contentPadding: EdgeInsets.only(right: 100, left: 100),
                      leading: Icon(Icons.person),
                      title: Text(suggestionList[index].name),
                      trailing:
                          Text('Address: ' + suggestionList[index].address),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            );
          },
        ),
      )),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    suggestionList = query.isEmpty
        ? recentSearch
        : customers.where((element) {
            return element.name.toLowerCase().startsWith(query.toLowerCase());
          }).toList();
    if (suggestionList.isEmpty) return Text('no search yet');
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(CustomerDetailScreen.routeName,
                arguments: suggestionList[index].id);
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
