import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/Model/stock.dart';
import 'package:manage/provider/stockdata.dart';
import 'package:provider/provider.dart';

class UpdateStockPaymentScreen extends StatefulWidget {
  static const routeName = '/UpdateStockPaymentScreen';

  @override
  _UpdateStockPaymentScreenState createState() =>
      _UpdateStockPaymentScreenState();
}

class _UpdateStockPaymentScreenState extends State<UpdateStockPaymentScreen> {
  bool isLoading = false;
  final _form = GlobalKey<FormState>();
  double amount = 0;

  @override
  Widget build(BuildContext context) {
    Stock stock = ModalRoute.of(context).settings.arguments as Stock;
    StockData stockData = Provider.of<StockData>(context);
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
                            } else if (double.parse(value) > stock.due) {
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
                                stock.paid += amount;
                                stock.due -= amount;
                                if (amount != 0)
                                  stock.paymentHistory.add({
                                    'date': DateFormat('dd-MM-yyyy')
                                        .format(DateTime.now()),
                                    'payment': amount
                                  });
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Add ' + amount.toString()),
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
                                              child: Text('cancel'))
                                        ],
                                      );
                                    }).then((value) async {
                                  if (value) {
                                    try {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await stockData.updatePayment(stock);
                                    } catch (e) {
                                      showDialog(
                                          barrierDismissible: false,
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
                              }
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
