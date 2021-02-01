import 'package:flutter/material.dart';
import 'package:manage/Model/Product.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';

class SingleProduct extends StatefulWidget {
  final int index;
  SingleProduct(this.index);

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<Products>(context).products;
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('name: ' + products[widget.index].name),
            Text('unitprice: ' +
                products[widget.index].unitPrice.toString() +
                ' / ' +
                products[widget.index].unitName),
            Text('available amount: ' +
                products[widget.index].availableAmount.toString())
          ],
        ),
      ),
    );
  }
}
