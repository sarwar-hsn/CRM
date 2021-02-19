import 'package:flutter/material.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';

class AddCategoriesScreen extends StatefulWidget {
  static const routeName = '/AddCatagoriesScreen';

  @override
  _AddCategoriesScreenState createState() => _AddCategoriesScreenState();
}

class _AddCategoriesScreenState extends State<AddCategoriesScreen> {
  bool isLoading = false;
  final _form = GlobalKey<FormState>();
  String category;

  @override
  Widget build(BuildContext context) {
    Products products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
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
                                if (products.checkDuplicate(category) ==
                                    false) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, true);
                                                  },
                                                  child: Text('confirm')),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, false);
                                                  },
                                                  child: Text('cancel'))
                                            ],
                                            content: Text('Add ' +
                                                '\'' +
                                                category +
                                                '\''));
                                      }).then((value) async {
                                    if (value) {
                                      try {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await products.addCategory(category);
                                      } catch (e) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Text(
                                                    'something went wrong !!!'),
                                                actions: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
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
                                  _form.currentState.reset();
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content:
                                              Text('Category already Present'),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('ok'))
                                          ],
                                        );
                                      });
                                }
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
