import 'package:flutter/material.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';

class AddCategoriesScreen extends StatefulWidget {
  static const routeName = '/AddCatagoriesScreen';

  @override
  _AddCategoriesScreenState createState() => _AddCategoriesScreenState();
}

class _AddCategoriesScreenState extends State<AddCategoriesScreen> {
  final _form = GlobalKey<FormState>();
  String category;

  @override
  Widget build(BuildContext context) {
    Products products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: Center(
        child: Container(
            height: 200,
            width: 300,
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextFormField(
                    style: TextStyle(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Field is empty';
                      } else if (double.tryParse(value) != null) {
                        return 'Numbers are not allowed';
                      } else
                        return null;
                    },
                    decoration: getInputDesign('Write a Category'),
                    onSaved: (value) {
                      setState(() {
                        category = value;
                      });
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_form.currentState.validate()) {
                          _form.currentState.save();
                          products.addCategory(category);
                          _form.currentState.reset();
                        }
                      },
                      child: Text('ADD'))
                ],
              ),
            )),
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
