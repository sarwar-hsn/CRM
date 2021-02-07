import 'package:flutter/material.dart';
import 'package:manage/Model/CustomerProduct.dart';
import 'package:manage/Model/PurchasedDate.dart';
import 'package:intl/intl.dart';

class CustomerProductDetail extends StatelessWidget {
  final mediaQuery;
  final customer;
  CustomerProductDetail({this.mediaQuery, this.customer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: mediaQuery.height * .5 - AppBar().preferredSize.height,
          child: (customer.products.isEmpty)
              ? Text('Customer has no products')
              : ListView.builder(
                  itemCount: customer.products.length,
                  itemBuilder: (context, index) {
                    PurchasedDate dateObj = customer.products[index];
                    return Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1)),
                      height: (mediaQuery.height * .5 -
                              AppBar().preferredSize.height) *
                          .4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(DateFormat('dd-MM-yyyy').format(dateObj.date)),
                          Container(
                            height: ((mediaQuery.height * .5 -
                                        AppBar().preferredSize.height) *
                                    .3) *
                                1,
                            child: GridView.builder(
                                itemCount: dateObj.products.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisExtent: 100, crossAxisCount: 5),
                                itemBuilder: (context, index) {
                                  CustomerProduct productObj =
                                      dateObj.products[index];
                                  return Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Product Name    :  ' +
                                              productObj.productName),
                                          Text('Unit Purchased   :  ' +
                                              productObj.unitPurchased
                                                  .toString()),
                                          Text('Product Price      :  ' +
                                              productObj.unitPrice.toString() +
                                              ' / ' +
                                              productObj.unitName),
                                          Text('Purchased Cost   :  ' +
                                              productObj.total.toString())
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    );
                  },
                )),
    );
  }
}
