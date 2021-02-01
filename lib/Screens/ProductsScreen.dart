import 'package:flutter/material.dart';
import 'package:manage/Model/Product.dart';
import 'package:manage/Widgets/SingleProduct.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';

import 'mainDrawer.dart';

class ProductsScreen extends StatelessWidget {
  static const routeName = '/productsScreen';
  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<Products>(context).products;
    return Scaffold(
      appBar: AppBar(
        title: Text('Products Screen'),
      ),
      drawer: MainDrawer(),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3,
          ),
          itemCount: products.length,
          itemBuilder: (context, int index) {
            return Container(
                height: 100, width: 100, child: SingleProduct(index));
          }),
    );
  }
}
