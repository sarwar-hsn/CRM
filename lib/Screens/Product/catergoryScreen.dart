import 'package:flutter/material.dart';
import 'package:manage/Screens/Product/ProductsScreen.dart';
import 'package:manage/Screens/Others/mainDrawer.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = '/categoryScreen';
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    List<String> categories = Provider.of<Products>(context).categories;
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      drawer: MainDrawer(),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black12, width: 1)),
          padding: EdgeInsets.all(20),
          height: mediaQuery.size.height * .8,
          width: mediaQuery.size.width * .3,
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    child: SizedBox.expand(
                      child: ElevatedButton(
                        child: Text(categories[index]),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              ProductsScreen.routeName,
                              arguments: categories[index]);
                        },
                      ),
                    ),
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey[300],
                        border: Border.all(
                          width: 1,
                          color: Colors.black26,
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
