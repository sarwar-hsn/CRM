import 'package:flutter/material.dart';
import 'package:manage/Screens/EditScreens.dart/EditProduct.dart';
import 'package:manage/Screens/Product/addCategories.dart';
import 'package:manage/Screens/Product/addProductsScreen.dart';
import 'package:manage/Screens/Cusomer/addcustomer.dart';
import 'package:manage/Screens/Cusomer/customerDetailScreen.dart';
import 'package:manage/Screens/Product/catergoryScreen.dart';
import 'package:manage/provider/Customers.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';
import 'Screens/Product/ProductsScreen.dart';
import 'Screens/Others/homepage.dart';
import 'Screens/Cusomer/customersScreen.dart';

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
          primarySwatch: Colors.blueGrey,
        ),
        home: HomePage(),
        routes: {
          AddProductsScreen.routeName: (context) => AddProductsScreen(),
          ProductsScreen.routeName: (context) => ProductsScreen(),
          CustomersScreen.routeName: (context) => CustomersScreen(),
          AddCustomerScreen.routeName: (context) => AddCustomerScreen(),
          CustomerDetailScreen.routeName: (context) => CustomerDetailScreen(),
          AddCategoriesScreen.routeName: (context) => AddCategoriesScreen(),
          CategoryScreen.routeName: (context) => CategoryScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen()
        },
      ),
    );
  }
}
