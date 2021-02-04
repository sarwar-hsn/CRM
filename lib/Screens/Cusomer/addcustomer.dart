import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/Model/CustomerProduct.dart';
import 'package:manage/Model/Product.dart';

import 'package:manage/Screens/Others/mainDrawer.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';

class AddCustomerScreen extends StatefulWidget {
  static const routeName = '/addCustomer';

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  DateTime pickedDate;
  double totalPrice = 0;
  List<CustomerProduct> pickedItems = [];
  String dropDownValue;

  Container getDatePickerContainer(BuildContext context, Function function) {
    return Container(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            height: 50,
            alignment: Alignment.centerLeft,
            width: double.infinity,
            child: (pickedDate == null)
                ? Text(
                    'no scheduled date for payment',
                    style: TextStyle(color: Colors.black45),
                  )
                : Text(
                    DateFormat('dd-MM-yyyy').format(pickedDate),
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
                child: ElevatedButton(
                    onPressed: function, child: Text('Pick a scheduled Date')),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        pickedDate = null;
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
        pickedDate = date;
      });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    Products obj = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer'),
      ),
      body: Center(
        child: Container(
          height: mediaQuery.size.height * .9,
          width: mediaQuery.size.width * .5,
          padding: EdgeInsets.all(20),
          child: Form(
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
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        border: Border.all(color: Colors.black45, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          dropdownColor: Colors.white,
                          value: dropDownValue,
                          icon: Icon(Icons.arrow_drop_down),
                          hint: Text('Select Product'),
                          onChanged: (newValue) {
                            setState(() {
                              dropDownValue = newValue;
                            });
                          },
                          items: obj.getProductsList().map((value) {
                            return DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            );
                          }).toList()),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  customDesignedContainer('Enter Amount :'),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: getInputDesign('amount'),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  customDesignedContainer('Price : '),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                        decoration: (dropDownValue == null)
                            ? getInputDesign('unit price')
                            : (((obj.getProductsbyCategory(dropDownValue))
                                        .length ==
                                    0))
                                ? getInputDesign('unit price')
                                : getInputDesign('unit price in ' +
                                    ((obj.getProductsbyCategory(
                                            dropDownValue))[0])
                                        .unitName)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      width: 200,
                      child: customDesignedContainer(
                          'total :  ' + totalPrice.toString())),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              getDatePickerContainer(context, _pickDate)
              //ElevatedButton(onPressed: _pickDate, child: Text('Pick a date'))
            ]),
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

Container customDesignedContainer(String text) {
  return Container(
    height: 50,
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(left: 10, right: 10),
    decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black45, width: 1)),
    child: Text(text),
  );
}
