import 'package:flutter/material.dart';
import 'package:manage/Screens/Customer/addcustomer.dart';
import 'package:manage/Screens/EditScreens.dart/EditProduct.dart';
import 'package:manage/Screens/EditScreens.dart/editCustomer.dart';
import 'package:manage/Screens/EditScreens.dart/updatepayment.dart';
import 'package:manage/Screens/Others/transaction.dart';
import 'package:manage/Screens/Product/addCategories.dart';
import 'package:manage/Screens/Product/addProductsScreen.dart';
import 'package:manage/Screens/Product/catergoryScreen.dart';
import 'package:manage/provider/Customers.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';
import 'Screens/Customer/addcustomerproductscreen.dart';
import 'Screens/Customer/customerDetailScreen.dart';
import 'Screens/Customer/customersScreen.dart';
import 'Screens/Product/ProductsScreen.dart';
import 'Screens/Others/homepage.dart';

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
          EditProductScreen.routeName: (context) => EditProductScreen(),
          UpdatePayment.routeName: (context) => UpdatePayment(),
          EditCustomerScreen.routeName: (context) => EditCustomerScreen(),
          AddCustomerProductScreen.routeName: (context) =>
              AddCustomerProductScreen(),
          TransactionHistoryScreen.routeName: (context) =>
              TransactionHistoryScreen(),
        },
      ),
    );
  }
}
