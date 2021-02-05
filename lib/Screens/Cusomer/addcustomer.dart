import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/Model/CustomerProduct.dart';
import 'package:manage/Model/Product.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';

class AddCustomerScreen extends StatefulWidget {
  static const routeName = '/addCustomer';

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  DateTime scheduledDate;
  DateTime customerProductDate = DateTime.now();
  DateTime customerDate = DateTime.now();
  CustomerProduct customerProduct = new CustomerProduct();
  List<CustomerProduct> pickedItems = [];
  Product dropDownValueProducts;
  String dropDownValueCategory;

  final _customerForm = GlobalKey<FormState>();
  final _customerProductForm = GlobalKey<FormState>();

  Container dateContainer(
      BuildContext context, Function function, String text) {
    return Container(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            height: 40,
            alignment: Alignment.centerLeft,
            width: double.infinity,
            child: (scheduledDate == null)
                ? Text(
                    'no date selected',
                    style: TextStyle(color: Colors.black45),
                  )
                : Text(
                    DateFormat('dd-MM-yyyy').format(scheduledDate),
                    textAlign: TextAlign.left,
                  ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white70,
                border: Border.all(color: Colors.black54, width: 1)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ElevatedButton(onPressed: function, child: Text(text)),
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
    if (isValid) {
      _customerProductForm.currentState.save();
      customerProduct.total =
          customerProduct.unitPrice * customerProduct.unitPurchased;
      customerProduct.productName = dropDownValueProducts.name;
      customerProduct.unitName = dropDownValueProducts.unitName;
      customerProduct.date = customerProductDate;

      setState(() {
        pickedItems.add(customerProduct);
        dropDownValueCategory = null;
        dropDownValueProducts = null;
      });
      _customerProductForm.currentState.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    Products obj = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer'),
      ),
      body: Row(
        children: [
          Container(
            height: mediaQuery.size.height * .9,
            width: mediaQuery.size.width * .5,
            padding: EdgeInsets.all(20),
            child: Form(
              key: _customerForm,
              child: ListView(children: [
                TextFormField(
                  decoration: getInputDesign('name'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: getInputDesign('mobile'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: getInputDesign('address'),
                ),
                SizedBox(
                  height: 15,
                ),
                Form(
                  key: _customerProductForm,
                  child: Column(
                    children: [
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
                                String temp = _doubleValidator(value);
                                if (temp == null) {
                                  customerProduct.unitPurchased =
                                      double.parse(value);
                                }
                                return temp;
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
                                if (temp == null) {
                                  customerProduct.unitPrice =
                                      double.parse(value);
                                }
                                return temp;
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
                          IconButton(
                            tooltip:
                                'select a date for this product. default is today',
                            icon: Icon(Icons.calendar_today),
                            onPressed: _pickDateforCustomerProduct,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            width: 150,
                            decoration: _decoration,
                            child: Text(DateFormat('dd-MM-yyyy')
                                .format(customerProductDate)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _saveCustomerProduct();
                              },
                              child: Text('ADD PRODUCT')),
                          SizedBox(
                            width: 10,
                          ),
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
                ),

                SizedBox(
                  height: 15,
                ),
                dateContainer(context, _pickDateforSchedule, 'scheduled date'),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(onPressed: () {}, child: Text('SAVE CUSTOMER'))
                //ElevatedButton(onPressed: _pickDate, child: Text('Pick a date'))
              ]),
            ),
          ),
          SizedBox(
            width: mediaQuery.size.width * .1,
          ),
          inputProductsContainer(context, pickedItems)
        ],
      ),
    );
  }
}

Stack inputProductsContainer(
    BuildContext context, List<CustomerProduct> items) {
  final mediaQuery = MediaQuery.of(context);
  double _totalPrice = 0;
  for (int i = 0; i < items.length; i++) {
    _totalPrice += items[i].total;
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
            (items.length == 0)
                ? Text('no items yet')
                : Expanded(
                    child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Card(
                              child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (items[index].productName == null)
                                    ? Text('Product name: _')
                                    : Text('Product name: ' +
                                        items[index].productName),
                                Text('purchased amount: ' +
                                    items[index].unitPurchased.toString() +
                                    ' ' +
                                    items[index].unitName),
                                Text('price: ' + items[index].total.toString()),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {},
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
