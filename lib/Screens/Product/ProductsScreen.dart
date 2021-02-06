import 'package:flutter/material.dart';
import 'package:manage/Model/Product.dart';
import 'package:manage/Widgets/SingleProduct.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  static const routeName = '/productsScreen';
  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context).settings.arguments as String;
    List<Product> products =
        Provider.of<Products>(context).getProductsbyCategory(category);
    // Provider.of<Products>(context).getProductsbyCategory(category);
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: (products.length == 0)
          ? Center(
              child: Text('No product in this Category yet'),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 200,
              ),
              itemCount: products.length,
              itemBuilder: (context, int index) {
                return Container(
                    child: SingleProduct(
                  product: products[index],
                ));
              }),
    );
  }
}
