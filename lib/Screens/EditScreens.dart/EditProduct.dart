import 'package:flutter/material.dart';
import 'package:manage/Model/Product.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
  static const routeName = '/EditProductScreen';

  final _form = GlobalKey<FormState>();

  void _updateProduct(Products products, BuildContext context) {
    bool isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      products.callListener();
      _form.currentState.reset();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    Products productsObj = Provider.of<Products>(context);
    final id = ModalRoute.of(context).settings.arguments;
    Product product = productsObj.getProductById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Center(
        child: Container(
          height: mediaQuery.height * .7,
          width: mediaQuery.width * .4,
          child: Form(
            key: _form,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Container(width: 150, child: Text('Product Name : ')),
                      Expanded(
                        child: TextFormField(
                          initialValue: product.name,
                          decoration: getInputDesign('name'),
                          onSaved: (value) {
                            product.name = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(width: 150, child: Text('Unit Price : ')),
                      Expanded(
                        child: TextFormField(
                          initialValue: product.unitPrice.toString(),
                          decoration: getInputDesign('unit price'),
                          validator: (value) {
                            if (double.tryParse(value) == null)
                              return 'Expects amount in number';
                            if (double.parse(value) < 0)
                              return 'number can\'t be less than 0';
                            return null;
                          },
                          onSaved: (value) {
                            product.unitPrice = double.parse(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(width: 150, child: Text('Unit Name : ')),
                      Expanded(
                        child: TextFormField(
                          initialValue: product.unitName.toString(),
                          decoration: getInputDesign('unit name'),
                          onSaved: (value) {
                            product.unitName = value;
                          },
                          validator: (value) {
                            if (double.tryParse(value) != null)
                              return 'Expects name';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(width: 150, child: Text('Available Amount : ')),
                      Expanded(
                        child: TextFormField(
                          initialValue: product.availableAmount.toString(),
                          decoration: getInputDesign('available amount'),
                          validator: (value) {
                            if (double.tryParse(value) == null)
                              return 'Expects amount in number';
                            if (double.parse(value) < 0)
                              return 'number can\'t be less than 0';
                            return null;
                          },
                          onSaved: (value) {
                            product.availableAmount = double.parse(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            _updateProduct(productsObj, context);
                          },
                          child: Text('Update Product'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration getInputDesign(String hintText) {
  return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      fillColor: Colors.white70,
      filled: true,
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.black38));
}
