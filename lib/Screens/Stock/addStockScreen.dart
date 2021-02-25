import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/Model/stock.dart';
import 'package:manage/provider/stockdata.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../Model/stock.dart';

class AddToStockScreen extends StatefulWidget {
  static const routeName = '/AddToStockScreen';

  @override
  _AddToStockScreenState createState() => _AddToStockScreenState();
}

class _AddToStockScreenState extends State<AddToStockScreen> {
  bool isLoading = false;

  String dropDownValue;
  DateTime date = DateTime.now();
  final _companyNameForm = GlobalKey<FormState>();
  final _form = GlobalKey<FormState>();
  Stock tempStock = new Stock();
  String companyName;

  double tempTotalUnit = 0;
  double tempUnitPrice = 0;
  double tempExtraFee = 0;
  double tempTotal = 0;

  Container dateContainer(
      BuildContext context, Function function, String text) {
    return Container(
      height: 100,
      width: 400,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(onPressed: function, child: Text(text)),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 40,
                alignment: Alignment.centerLeft,
                child: (date == null)
                    ? Text(
                        'no date selected',
                        style: TextStyle(color: Colors.black45),
                      )
                    : Text(
                        DateFormat('dd-MM-yyyy').format(date),
                        textAlign: TextAlign.left,
                      ),
                decoration: _decoration),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    date = null;
                  });
                },
                child: Text('clear date')),
          )
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
    );
    if (date != null)
      setState(() {
        this.date = date;
      });
  }

  void _saveStock(StockData stocks) {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      tempStock.totalCost = double.parse(
          (tempStock.unitPrice * tempStock.totalUnit + tempStock.extraFee)
              .toStringAsFixed(2));
      tempStock.due = double.parse(
          (tempStock.totalCost - tempStock.paid).toStringAsFixed(2));
      tempStock.companyName = dropDownValue;

      tempStock.id = Uuid().v1();
      tempStock.date = DateFormat('dd-MM-yyyy').format(date);
      if (dropDownValue == null)
        tempStock.companyName = 'Unknown';
      else
        tempStock.companyName = dropDownValue;
      tempStock.paymentHistory = [
        {
          'date': DateFormat('dd-MM-yyyy').format(date),
          'payment': tempStock.paid
        }
      ];

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you Confirmed ? '),
              content: Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Company name: ' + tempStock.companyName),
                    Text('Prduct name: ' + tempStock.productName),
                    Text('Total: ' + tempStock.totalCost.toString()),
                    Text('Transportation / Extra: ' +
                        tempStock.extraFee.toString()),
                    Text('Paid: ' + tempStock.paid.toString()),
                    Text(
                      'due: ' + tempStock.due.toString(),
                    ),
                    Text('Date : ' + tempStock.date)
                  ],
                ),
              ),
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
            await stocks.addStock(new Stock(
                companyName: tempStock.companyName,
                date: tempStock.date,
                due: double.parse(tempStock.due.toStringAsFixed(2)),
                extraFee: double.parse(tempStock.extraFee.toStringAsFixed(2)),
                id: tempStock.id,
                paid: double.parse(tempStock.paid.toStringAsFixed(2)),
                productName: tempStock.productName,
                totalCost: double.parse(tempStock.totalCost.toStringAsFixed(2)),
                totalUnit: double.parse(tempStock.totalUnit.toStringAsFixed(2)),
                unitPrice: double.parse(tempStock.unitPrice.toStringAsFixed(2)),
                paymentHistory: tempStock.paymentHistory,
                isActive: true));
          } catch (e) {
            showDialog(
                barrierDismissible: false,
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
            dropDownValue = null;
            date = DateTime.now();
            tempExtraFee = 0;
            tempUnitPrice = 0;
            tempTotal = 0;
            tempTotalUnit = 0;
            dropDownValue = null;
          });
        }
      });
      _form.currentState.reset();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    StockData stockData = Provider.of<StockData>(context);
    List<String> companies = stockData.companies;

    return Scaffold(
        appBar: AppBar(title: Text('Add to Stock')),
        body: (isLoading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blueGrey[200], Colors.white70])),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _form,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                //container to hold drop down companies
                                decoration: _decoration,
                                width: 500,
                                height: 40,
                                padding: EdgeInsets.all(8),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                  value: dropDownValue,
                                  hint: Text('select Company'),
                                  onChanged: (value) {
                                    setState(() {
                                      dropDownValue = value;
                                    });
                                  },
                                  items: companies.map((value) {
                                    return DropdownMenuItem(
                                      child: Text(value.toString()),
                                      value: value,
                                    );
                                  }).toList(),
                                )),
                              ),
                              // FutureBuilder(
                              //     future: Provider.of<StockData>(context,
                              //             listen: false)
                              //         .fetchAndSetCompanies(),
                              //     builder: (context, snapshot) {
                              //       if (snapshot.hasError) {
                              //         return Container(
                              //           child: Text(
                              //               'Failed to load your company list'),
                              //         );
                              //       }
                              //       if (snapshot.hasData) {
                              //         companies = snapshot.data as List<String>;

                              //       }

                              //       return Container(
                              //         child: CircularProgressIndicator(),
                              //       );
                              //     }),

                              Container(
                                // product name in stock
                                width: 500,
                                height: 50,
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  decoration: getInputDesign('product name'),
                                  validator: (value) {
                                    if (double.tryParse(value) != null) {
                                      return 'only numbers not allowed';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value.isEmpty)
                                      tempStock.productName =
                                          '___'; //if the value is null then compamy name is ___
                                    else
                                      tempStock.productName = value;
                                  },
                                ),
                              ),
                              Container(
                                width: 500,
                                height: 50,
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  decoration: getInputDesign('Unit Purchased'),
                                  onChanged: (value) {
                                    if (_doubleValidator(value) == null) {
                                      tempTotalUnit = double.parse(value);
                                      tempTotalUnit = double.parse(
                                          tempTotalUnit.toStringAsFixed(2));
                                    }
                                  },
                                  validator: (value) {
                                    return _doubleValidator(value);
                                  },
                                  onSaved: (value) {
                                    tempStock.totalUnit = double.parse(
                                        double.parse(value).toStringAsFixed(2));
                                  },
                                ),
                              ),
                              Container(
                                width: 500,
                                height: 50,
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  decoration: getInputDesign('Unit price'),
                                  onChanged: (value) {
                                    if (_doubleValidator(value) == null) {
                                      tempUnitPrice = double.parse(
                                          double.parse(value)
                                              .toStringAsFixed(2));
                                    }
                                  },
                                  validator: (value) {
                                    return _doubleValidator(value);
                                  },
                                  onSaved: (value) {
                                    tempStock.unitPrice = double.parse(
                                        double.parse(value).toStringAsFixed(2));
                                  },
                                ),
                              ),
                              Container(
                                width: 500,
                                height: 50,
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  decoration: getInputDesign(
                                      'Transportation Fee / Extras'),
                                  onChanged: (value) {
                                    if (_doubleValidator(value) == null) {
                                      tempExtraFee = double.parse(
                                          double.parse(value)
                                              .toStringAsFixed(2));
                                    }
                                  },
                                  validator: (value) {
                                    return _doubleValidator(value);
                                  },
                                  onSaved: (value) {
                                    tempStock.extraFee = double.parse(
                                        double.parse(value).toStringAsFixed(2));
                                  },
                                ),
                              ),
                              Container(
                                  width: 500,
                                  height: 50,
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              tempTotal = tempTotalUnit *
                                                      tempUnitPrice +
                                                  tempExtraFee;
                                            });
                                          },
                                          child: Text('Calculate Total : ')),
                                      Text(tempTotalUnit.toString() +
                                          ' * ' +
                                          tempUnitPrice.toString() +
                                          ' + ' +
                                          tempExtraFee.toString() +
                                          ' = ' +
                                          tempTotal.toStringAsFixed(2))
                                    ],
                                  )),
                              Container(
                                width: 500,
                                height: 50,
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  decoration: getInputDesign('Paid'),
                                  validator: (value) {
                                    return _doubleValidator(value);
                                  },
                                  onSaved: (value) {
                                    tempStock.paid = double.parse(value);
                                  },
                                ),
                              ),
                              dateContainer(context, _pickDate, 'Select Date'),
                              ElevatedButton(
                                  onPressed: () {
                                    _saveStock(stockData);
                                  },
                                  child: Text('ADD'))
                            ],
                          ),
                        ),
                        Form(
                          key: _companyNameForm,
                          child: Column(
                            children: [
                              Container(
                                width: 500,
                                height: 50,
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  decoration: getInputDesign('Add Company'),
                                  validator: (value) {
                                    if (double.tryParse(value) != null) {
                                      return 'numbers not allowed';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    companyName = value;
                                  },
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_companyNameForm.currentState
                                        .validate()) {
                                      _companyNameForm.currentState.save();
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text(
                                                  'only add if you deal with frequently. Confirm ?'),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                    child: Text('Confirm')),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, false);
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
                                            await stockData
                                                .addCompany(companyName);
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
                                                            Navigator.of(
                                                                    context)
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
                                      _companyNameForm.currentState.reset();
                                    }
                                  },
                                  child: Text('Add Company'))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}

final _decoration = BoxDecoration(
    color: Colors.white70,
    border: Border.all(color: Colors.black45, width: 1),
    borderRadius: BorderRadius.circular(10));

InputDecoration getInputDesign(String hintText) {
  return InputDecoration(
      contentPadding: EdgeInsets.only(left: 10, right: 5, top: 15, bottom: 15),
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      fillColor: Colors.white70,
      filled: true,
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.black38));
}

String _doubleValidator(String value) {
  if (value.isEmpty) {
    return 'Field is empty';
  }
  if (double.tryParse(value) == null) {
    return 'only numbers are allowed';
  }
  if (double.parse(value) < 0) {
    return 'negetive number not allowed';
  }
  return null;
}

Stock deepCopyStock(Stock tempStock) {
  Stock temp = new Stock(
    companyName: tempStock.companyName,
    due: tempStock.due,
    extraFee: tempStock.extraFee,
    paid: tempStock.paid,
    productName: tempStock.productName,
    totalCost: tempStock.totalCost,
    totalUnit: tempStock.totalUnit,
    unitPrice: tempStock.unitPrice,
  );
  return temp;
}
