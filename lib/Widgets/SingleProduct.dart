import 'package:flutter/material.dart';
import 'package:manage/Model/Product.dart';
import 'package:manage/Screens/EditScreens.dart/EditProduct.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';

class SingleProduct extends StatelessWidget {
  final Product product;
  SingleProduct({this.product});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'name: ' + product.name,
                    style: _textStyle(),
                  ),
                  IconButton(
                    tooltip: 'Edit this Product',
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          EditProductScreen.routeName,
                          arguments: product.id);
                    },
                    icon: Icon(Icons.edit),
                    color: Colors.white,
                    iconSize: 20,
                  )
                ],
              ),
              Text(
                'unitprice: ' +
                    product.unitPrice.toString() +
                    ' / ' +
                    product.unitName,
                style: _textStyle(),
              ),
              SizedBox(
                height: 10,
              ),
              Text('available amount: ' + product.availableAmount.toString(),
                  style: _textStyle()),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle _textStyle() {
  return TextStyle(color: Colors.white);
}
