import 'package:flutter/material.dart';
import 'package:manage/Model/Customer.dart';
import 'package:manage/Screens/addProductsScreen.dart';
import 'package:manage/Screens/addcustomer.dart';
import 'package:manage/Screens/customerDetailScreen.dart';
import 'package:manage/provider/Customers.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';
import './Screens/ProductsScreen.dart';
import './Screens/homepage.dart';
import './Screens/customersScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Products()),
        ChangeNotifierProvider(create: (context) => Customers()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: HomePage(),
        routes: {
          AddProductsScreen.routeName: (context) => AddProductsScreen(),
          ProductsScreen.routeName: (context) => ProductsScreen(),
          CustomersScreen.routeName: (context) => CustomersScreen(),
          AddCustomerScreen.routeName: (context) => AddCustomerScreen(),
          CustomerDetailScreen.routeName: (context) => CustomerDetailScreen(),
        },
      ),
    );
  }
}
