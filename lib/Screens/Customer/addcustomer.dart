import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/Model/Customer.dart';
import 'package:manage/Model/CustomerProduct.dart';
import 'package:manage/Model/Product.dart';
import 'package:manage/Model/PurchasedDate.dart';
import 'package:manage/provider/Customers.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import '../../Model/CustomerProduct.dart';

class AddCustomerScreen extends StatefulWidget {
  static const routeName = '/addCustomer';

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  bool isLoading = false;

  DateTime scheduledDate;
  DateTime customerProductDate = DateTime.now();

  List<CustomerProduct> pickedItems = [];
  CustomerProduct customerProduct = new CustomerProduct();
  Product dropDownValueProducts;
  String dropDownValueCategory;

  Customer customer = new Customer();
  PurchasedDate purchasedDate = new PurchasedDate();
  List<PurchasedDate> dates = [];

  final _customerForm = GlobalKey<FormState>();
  final _customerProductForm = GlobalKey<FormState>();

  AlertDialog getAlertDialog(Customers obj, Customer customer) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text('Customer Overview'),
      content: Container(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('name: ' + customer.name),
            Text('mobile: ' + customer.mobile),
            Text('address: ' + customer.address),
            Text('total: ' + customer.total.toString()),
            Text('paid: ' + customer.paid.toString()),
            Text(
              'due: ' + customer.due.toString(),
            ),
            if (customer.schedulePay != null)
              Text('schedule payment day : ' + customer.schedulePay)
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
            child: Text('no'))
      ],
    );
  }

  void _saveCustomerForm(Customers obj) {
    bool isValid = _customerForm.currentState.validate();
    if (isValid) {
      _customerForm.currentState.save();
      if (scheduledDate != null)
        customer.schedulePay = DateFormat('dd-MM-yyyy').format(scheduledDate);
      else
        customer.schedulePay = null;
      PurchasedDate tempPurchasedDate = new PurchasedDate(
          date: DateFormat('dd-MM-yyyy').format(customerProductDate),
          products: List.from(pickedItems));
      double total = 0;

      for (int i = 0; i < tempPurchasedDate.products.length; i++) {
        total += tempPurchasedDate.products[i].total;
      }
      //due
      double due = total - customer.paid;

      customer.due = due;
      customer.total = total;

      if (tempPurchasedDate.products.length == 0) {
        customer.products = [
          new PurchasedDate(date: 'NOT SPECIFIED', products: [
            CustomerProduct(
                id: 'not specified',
                productName: 'not specified',
                total: 0,
                unitName: 'not specified',
                unitPrice: 0,
                unitPurchased: 0),
          ])
        ];
      } else
        customer.products = [tempPurchasedDate];
      customer.id = Uuid().v1();
      // if (customer.paid != 0) {
      customer.paymentDate = [
        {
          'date': DateFormat('dd-MM-yyyy').format(DateTime.now()),
          'paid': customer.paid
        }
      ];
      // } else {
      //   customer.paymentDate = [{}];
      // }
      // customer.paymentDate.add();

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return getAlertDialog(obj, customer);
          }).then((value) async {
        if (value) {
          setState(() {
            isLoading = true;
          });
          try {
            await obj.addCustomer(new Customer(
                address: customer.address,
                due: customer.due,
                id: customer.id,
                mobile: customer.mobile,
                name: customer.name,
                paid: customer.paid,
                paymentDate: customer.paymentDate,
                products: customer.products,
                schedulePay: customer.schedulePay,
                total: customer.total));
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
            scheduledDate = null;
            customerProductDate = DateTime.now();
            pickedItems.clear();
          });
        }
      });
    }
  }

  Container dateContainer(
      BuildContext context, Function function, String text) {
    Customers obj = Provider.of<Customers>(context);
    return Container(
      height: 100,
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
                child: (scheduledDate == null)
                    ? Text(
                        'no date selected',
                        style: TextStyle(color: Colors.black45),
                      )
                    : Text(
                        DateFormat('dd-MM-yyyy').format(scheduledDate),
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
                    scheduledDate = null;
                  });
                },
                child: Text('clear date')),
          )
        ],
      ),
    );
  }

  Future<void> _pickDateforCustomerProduct() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
    );
    if (date != null)
      setState(() {
        customerProductDate = date;
      });
  }

  Future<void> _pickDateforSchedule() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
    );
    if (date != null)
      setState(() {
        scheduledDate = date;
      });
  }

  final _decoration = BoxDecoration(
      color: Colors.white70,
      border: Border.all(color: Colors.black45, width: 1),
      borderRadius: BorderRadius.circular(10));

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

  void _saveCustomerProduct() {
    bool isValid = _customerProductForm.currentState.validate();
    if (isValid && dropDownValueProducts != null) {
      _customerProductForm.currentState.save();
      customerProduct.total =
          customerProduct.unitPrice * customerProduct.unitPurchased;
      customerProduct.productName = dropDownValueProducts.name;
      customerProduct.unitName = dropDownValueProducts.unitName;

      pickedItems.add(new CustomerProduct(
        id: Uuid().v5(Uuid.NAMESPACE_URL, 'www.google.com'),
        productName: customerProduct.productName,
        unitName: customerProduct.unitName,
        total: customerProduct.total,
        unitPurchased: customerProduct.unitPurchased,
        unitPrice: customerProduct.unitPrice,
      ));
      setState(() {
        dropDownValueCategory = null;
        dropDownValueProducts = null;
      });
      _customerProductForm.currentState.reset();
    }
  }

  String _stringValidator(String value) {
    if (value.isEmpty)
      return 'empty field';
    else if (double.tryParse(value) != null)
      return 'numbers not allowed';
    else
      return null;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Products products = Provider.of<Products>(context, listen: false);
      products.fetchAndSetCategories();
      products.fetchAndSetProducts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    Customers customerObj = Provider.of<Customers>(context);
    Products obj = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer'),
      ),
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Row(
              children: [
                Container(
                  height: mediaQuery.size.height * .9,
                  width: mediaQuery.size.width * .5,
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _customerForm,
                    child: ListView(children: [
                      TextFormField(
                        initialValue: 'sarwar',
                        decoration: getInputDesign('name'),
                        validator: (value) {
                          return _stringValidator(value);
                        },
                        onSaved: (value) {
                          customer.name = value;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: getInputDesign('mobile'),
                        initialValue: '01733202514',
                        validator: (value) {
                          if (int.tryParse(value) != null &&
                              value.length == 11) {
                            return null;
                          }
                          return 'Invalid number';
                        },
                        onSaved: (value) {
                          customer.mobile = value;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: getInputDesign('address'),
                        initialValue: 'birampur',
                        validator: (value) {
                          return _stringValidator(value);
                        },
                        onSaved: (value) {
                          customer.address = value;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Form(
                        key: _customerProductForm,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ElevatedButton(
                                    onPressed: (pickedItems.isEmpty)
                                        ? _pickDateforCustomerProduct
                                        : null,
                                    child: Text(
                                        'Selecet a date for prducts ( default is today ) :')),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    width: 150,
                                    decoration: _decoration,
                                    child: Text(DateFormat('dd-MM-yyyy')
                                        .format(customerProductDate)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    padding: EdgeInsets.all(8),
                                    decoration: _decoration,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          hint: Text('Select Category'),
                                          value: dropDownValueCategory,
                                          onChanged: (value) {
                                            setState(() {
                                              dropDownValueCategory = value;
                                              dropDownValueProducts = null;
                                            });
                                          },
                                          items: obj.categories.map((value) {
                                            return DropdownMenuItem(
                                              child: Text(value),
                                              value: value,
                                            );
                                          }).toList()),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    padding: EdgeInsets.all(8),
                                    decoration: _decoration,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        hint: Text('select Product'),
                                        value: dropDownValueProducts,
                                        onChanged: (value) {
                                          setState(() {
                                            dropDownValueProducts = value;
                                          });
                                        },
                                        items: obj
                                            .getProductsbyCategory(
                                                dropDownValueCategory)
                                            .map((value) {
                                          return DropdownMenuItem(
                                            child: Text(value.name),
                                            value: value,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: <Widget>[
                                customDesignedContainer('Unit Purchase :'),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: getInputDesign('amount...'),
                                    validator: (value) {
                                      return _doubleValidator(value);
                                    },
                                    onSaved: (value) {
                                      customerProduct.unitPurchased =
                                          double.parse(value);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                customDesignedContainer('Unit Price : '),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    validator: (value) {
                                      String temp = _doubleValidator(value);

                                      return temp;
                                    },
                                    onSaved: (value) {
                                      customerProduct.unitPrice =
                                          double.parse(value);
                                    },
                                    decoration: (dropDownValueProducts == null)
                                        ? getInputDesign('unit price')
                                        : getInputDesign(dropDownValueProducts
                                                .unitPrice
                                                .toString() +
                                            ' / ' +
                                            dropDownValueProducts.unitName),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      _saveCustomerProduct();
                                    },
                                    child: Text('ADD PRODUCT')),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: getInputDesign('paid amount'),
                        validator: (value) {
                          String temp = _doubleValidator(value);
                          return temp;
                        },
                        onSaved: (value) {
                          customer.paid = double.parse(value);
                        },
                      ),
                      dateContainer(
                          context, _pickDateforSchedule, 'scheduled date'),
                      ElevatedButton(
                          onPressed: () {
                            _saveCustomerForm(customerObj);
                          },
                          child: Text('SAVE CUSTOMER'))
                    ]),
                  ),
                ),
                SizedBox(
                  width: mediaQuery.size.width * .1,
                ),
                inputProductsContainer()
              ],
            ),
    );
  }

  Stack inputProductsContainer() {
    final mediaQuery = MediaQuery.of(context);
    double _totalPrice = 0;
    for (int i = 0; i < pickedItems.length; i++) {
      _totalPrice += pickedItems[i].total;
    }
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
          color: Colors.red[50],
          width: mediaQuery.size.width * .3,
          height: mediaQuery.size.height * .9,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'List of added products',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: mediaQuery.size.height * .02,
              ),
              (pickedItems.length == 0)
                  ? Text('no items yet')
                  : Expanded(
                      child: ListView.builder(
                          itemCount: pickedItems.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Card(
                                child: Text('Date : ' +
                                    DateFormat('dd-MM-yyyyy')
                                        .format(customerProductDate)),
                              );
                            }
                            index -= 1;
                            return Card(
                                child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (pickedItems[index].productName == null)
                                      ? Text('Product name: _')
                                      : Text('Product name: ' +
                                          pickedItems[index].productName),
                                  Text('purchased unit: ' +
                                      pickedItems[index]
                                          .unitPurchased
                                          .toString() +
                                      ' ' +
                                      pickedItems[index].unitName),
                                  Text('unit price: ' +
                                      pickedItems[index].unitPrice.toString()),
                                  Text('price: ' +
                                      pickedItems[index].total.toString()),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              pickedItems.removeAt(index);
                                            });
                                          },
                                          child: Text('Remove')),
                                    ],
                                  )
                                ],
                              ),
                            ));
                          }),
                    )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black45, width: 1),
              borderRadius: BorderRadius.circular(10)),
          width: mediaQuery.size.width * .3,
          height: 40,
          alignment: Alignment.center,
          child: Text(
            'Total Cost : ' + _totalPrice.toString() + '   Taka',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

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

Container customDesignedContainer(String text) {
  return Container(
    height: 40,
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(left: 10, right: 10),
    decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black45, width: 1)),
    child: Text(text),
  );
}
