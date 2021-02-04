import 'package:flutter/material.dart';
import 'package:manage/Model/Product.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';

class SingleProduct extends StatelessWidget {
  final Product product;
  SingleProduct({this.product});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('name: ' + product.name),
              Text('unitprice: ' +
                  product.unitPrice.toString() +
                  ' / ' +
                  product.unitName),
              Text('available amount: ' + product.availableAmount.toString()),
              Text('category: ' + product.category),
            ],
          ),
        ),
      ),
    );
  }
}
