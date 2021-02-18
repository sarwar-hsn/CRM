import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/Model/Customer.dart';

import 'package:flutter/material.dart';
import 'package:manage/provider/Customers.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';

class UpdatePayment extends StatefulWidget {
  static const routeName = '/UpdatePayment';

  @override
  _UpdatePaymentState createState() => _UpdatePaymentState();
}

class _UpdatePaymentState extends State<UpdatePayment> {
  bool isLoading = false;
  final _form = GlobalKey<FormState>();
  double amount = 0;

  @override
  Widget build(BuildContext context) {
    Customer customer = ModalRoute.of(context).settings.arguments;
    final obj = Provider.of<Customers>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Payment'),
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
                            } else if (double.tryParse(value) == null) {
                              return 'only numbers';
                            } else if (double.parse(value) < 0) {
                              return 'negetive number not allowed';
                            } else if (double.parse(value) > customer.due) {
                              return 'payment is more than due';
                            } else
                              return null;
                          },
                          decoration: getInputDesign('amount'),
                          onSaved: (value) {
                            setState(() {
                              amount = double.parse(value);
                            });
                          },
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (_form.currentState.validate()) {
                                _form.currentState.save();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                          'new payment : ' + amount.toString()),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                            child: Text('Confirm')),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: Text('Cancel'))
                                      ],
                                    );
                                  },
                                ).then((value) async {
                                  if (value) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    customer.paid += amount;
                                    customer.due -= amount;
                                    if (amount != 0) {
                                      customer.paymentDate.add({
                                        'date': DateFormat('dd-MM-yyyy')
                                            .format(DateTime.now()),
                                        'paid': amount
                                      });
                                    }
                                    try {
                                      await Provider.of<Customers>(context,
                                              listen: false)
                                          .updateCustomerPayment(customer);
                                    } catch (e) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text(
                                                  'Something went wrong !!!'),
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
                              }
                              _form.currentState.reset();
                            },
                            child: Text('ADD PAYMENT'))
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
