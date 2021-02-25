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

class AddCustomerProductScreen extends StatefulWidget {
  static const routeName = '/AddCustomerProductScreen';

  @override
  _AddCustomerProductScreenState createState() =>
      _AddCustomerProductScreenState();
}

class _AddCustomerProductScreenState extends State<AddCustomerProductScreen> {
  bool isLoading = false;
  double amountPaid = 0;
  final _customerProductForm = GlobalKey<FormState>();
  final _updateForm = GlobalKey<FormState>();
  DateTime customerProductDate = DateTime.now();
  List<CustomerProduct> pickedItems = [];
  CustomerProduct customerProduct = new CustomerProduct();
  Product dropDownValueProducts;
  String dropDownValueCategory;
  int flag = 0;

  void _updateCustomer(Customer customer, Customers obj, Products prodObj) {
    if (_updateForm.currentState.validate()) {
      _updateForm.currentState.save();

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
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
          customer.paid += amountPaid;
          double total = 0;
          for (int j = 0; j < pickedItems.length; j++) {
            total += pickedItems[j].total;
          }
          customer.total += double.parse(total.toStringAsFixed(2));
          customer.due =
              double.parse((customer.total - customer.paid).toStringAsFixed(2));

          for (int i = 0; i < customer.products.length; i++) {
            if (customer.products[i].date ==
                DateFormat('dd-MM-yyyy').format(customerProductDate)) {
              for (int j = 0; j < pickedItems.length; j++) {
                customer.products[i].products.add(pickedItems[j]);
              }

              if (amountPaid != 0)
                customer.paymentDate.add({
                  'date': DateFormat('dd-MM-yyyy').format(customerProductDate),
                  'paid': amountPaid
                });

              setState(() {
                isLoading = true;
              });

              try {
                await obj.addCustomerProduct(customer); //products for same date
                for (int i = 0; i < pickedItems.length; i++) {
                  Product temp =
                      prodObj.getProductByName(pickedItems[i].productName);
                  await prodObj.editProduct(temp);
                }
              } catch (e) {
                print(e.toString());
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
                pickedItems.clear();
              });
              return;
            }
          }
          customer.products.add(new PurchasedDate(
              date: DateFormat('dd-MM-yyyy').format(customerProductDate),
              products: List.from(pickedItems)));
          _updateForm.currentState.reset();

          if (amountPaid != 0)
            customer.paymentDate.add({
              'date': DateFormat('dd-MM-yyyy').format(customerProductDate),
              'paid': amountPaid
            });
          setState(() {
            isLoading = true;
          });
          try {
            await obj.addCustomerProduct(customer);
            for (int i = 0; i < pickedItems.length; i++) {
              Product temp =
                  prodObj.getProductByName(pickedItems[i].productName);
              await prodObj.editProduct(temp);
            }
          } catch (e) {
            print(e.toString());
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

          //products for different day
          setState(() {
            isLoading = false;
            pickedItems.clear();
          });
          //Navigator.of(context).pop();
        }
      });
    }
  }

  void _saveCustomerProduct(Products obj) {
    bool isValid = _customerProductForm.currentState.validate();
    if (isValid && dropDownValueProducts != null) {
      _customerProductForm.currentState.save();
      customerProduct.total =
          customerProduct.unitPrice * customerProduct.unitPurchased;
      customerProduct.productName = dropDownValueProducts.name;
      customerProduct.unitName = dropDownValueProducts.unitName;

      pickedItems.add(new CustomerProduct(
        id: Uuid().v1(),
        productName: customerProduct.productName,
        unitName: customerProduct.unitName,
        total: double.parse(customerProduct.total.toStringAsFixed(2)),
        unitPurchased:
            double.parse(customerProduct.unitPurchased.toStringAsFixed(2)),
        unitPrice: double.parse(customerProduct.unitPrice.toStringAsFixed(2)),
      ));
      _customerProductForm.currentState.reset();
      setState(() {
        obj.getProductByName(customerProduct.productName).availableAmount -=
            customerProduct.unitPurchased;
        dropDownValueCategory = null;
        dropDownValueProducts = null;
      });
    }
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

  final _decoration = BoxDecoration(
      color: Colors.white70,
      border: Border.all(color: Colors.black45, width: 1),
      borderRadius: BorderRadius.circular(10));
  @override
  Widget build(BuildContext context) {
    Products obj = Provider.of<Products>(context);
    Customer customer = ModalRoute.of(context).settings.arguments;
    Customers customers = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product to ' + customer.name),
      ),
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .6,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100, left: 20),
                      child: Form(
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
                                    decoration: (dropDownValueProducts == null)
                                        ? getInputDesign('amount')
                                        : getInputDesign('available ' +
                                            obj
                                                .getProductById(
                                                    dropDownValueProducts.id)
                                                .availableAmount
                                                .toStringAsFixed(2)),
                                    validator: (value) {
                                      String temp = _doubleValidator(value);
                                      if (temp != null)
                                        return _doubleValidator(value);
                                      if (dropDownValueProducts == null) {
                                        return 'Select a Product to enter amount';
                                      }
                                      if (dropDownValueProducts != null &&
                                          obj
                                                  .getProductById(
                                                      dropDownValueProducts.id)
                                                  .availableAmount <
                                              double.parse(value)) {
                                        return 'Insufficient amount';
                                      }
                                      return null;
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
                                                .toStringAsFixed(2) +
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
                                      _saveCustomerProduct(obj);
                                    },
                                    child: Text('ADD PRODUCT')),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Form(
                              key: _updateForm,
                              child: Column(
                                children: [
                                  TextFormField(
                                    decoration: getInputDesign('paid amount'),
                                    validator: (value) {
                                      return _doubleValidator(value);
                                    },
                                    onSaved: (value) {
                                      amountPaid = double.parse(value);
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        _updateCustomer(
                                            customer, customers, obj);
                                      },
                                      child: Text('  DONE  ')),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .05,
                  ),
                  inputProductsContainer(customer, obj)
                ],
              ),
            ),
    );
  }

  Stack inputProductsContainer(Customer customer, Products obj) {
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
                                              CustomerProduct temp =
                                                  pickedItems.removeAt(index);
                                              obj
                                                      .getProductByName(
                                                          temp.productName)
                                                      .availableAmount +=
                                                  temp.unitPurchased;
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
            'Total Cost : ' +
                _totalPrice.toString() +
                '   Taka' +
                '  |  Previous Due : ' +
                customer.due.toString() +
                ' Taka',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
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
