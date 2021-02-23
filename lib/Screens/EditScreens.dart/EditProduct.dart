import 'package:flutter/material.dart';
import 'package:manage/Model/Product.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/EditProductScreen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool isLoading = false;

  final _form = GlobalKey<FormState>();

  void _updateProduct(
      Products products, BuildContext context, Product product) {
    bool isValid = _form.currentState.validate();

    if (isValid) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Edit Product Confirmed ?'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text('confirm')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text('cancel')),
              ],
            );
          }).then((value) async {
        if (value) {
          _form.currentState.save();
          try {
            setState(() {
              isLoading = true;
            });
            await products.editProduct(product);
          } catch (e) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('something went wrong !!!'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('okay'))
                    ],
                  );
                });
          }
          setState(() {
            isLoading = false;
          });
        }
      });
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
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
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
                            Container(
                                width: 150, child: Text('Product Name : ')),
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
                                initialValue:
                                    product.unitPrice.toStringAsFixed(2),
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
                            Container(
                                width: 150, child: Text('Available Amount : ')),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    product.availableAmount.toStringAsFixed(2),
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
                                  _updateProduct(productsObj, context, product);
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
