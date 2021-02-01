import 'package:flutter/material.dart';
import 'package:manage/Screens/mainDrawer.dart';
import 'package:manage/Model/Product.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class AddProductsScreen extends StatefulWidget {
  static const routeName = '/addProductsScreen';

  @override
  _AddProductsScreenState createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  final _form = GlobalKey<FormState>();
  Product temp = new Product();

  InputDecoration getInputDesign(String hintText) {
    return InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        fillColor: Colors.white70,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black38));
  }

  void _saveform(Products obj, BuildContext context) {
    bool isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      print(temp.name);
      print(temp.unitPrice);
      print(temp.unitName);
      print(temp.availableAmount);
      obj.addProduct(temp);

      _form.currentState.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    Products products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Products'),
      ),
      drawer: MainDrawer(),
      body: Center(
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          shadowColor: Colors.blueGrey.withOpacity(.2),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey.withOpacity(.5)),
            alignment: Alignment.topCenter,
            height: 400,
            width: 500,
            child: Form(
              key: _form,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFormField(
                      decoration: getInputDesign('name'),
                      onSaved: (value) {
                        temp.name = value;
                      },
                    ),
                    TextFormField(
                      decoration: getInputDesign('unit price'),
                      validator: (value) {
                        if (double.parse(value) == null)
                          return 'Expects amount in number';
                        if (double.parse(value) < 0)
                          return 'number can\'t be less than 0';
                        return null;
                      },
                      onSaved: (value) {
                        temp.unitPrice = double.parse(value);
                      },
                    ),
                    TextFormField(
                      decoration: getInputDesign('unit name'),
                      onSaved: (value) {
                        temp.unitName = value;
                      },
                    ),
                    TextFormField(
                      decoration: getInputDesign('available amount'),
                      validator: (value) {
                        if (double.parse(value) == null)
                          return 'Expects amount in number';
                        if (double.parse(value) < 0)
                          return 'number can\'t be less than 0';
                        return null;
                      },
                      onSaved: (value) {
                        temp.availableAmount = double.parse(value);
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _saveform(products, context);
                      },
                      child: Container(
                        height: 40,
                        width: 200,
                        child: Center(
                          child: Text(
                            'SUBMIT',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
