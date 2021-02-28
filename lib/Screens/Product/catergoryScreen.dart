import 'package:flutter/material.dart';
import 'package:manage/Screens/Product/ProductsScreen.dart';
import 'package:manage/Screens/Others/mainDrawer.dart';
import 'package:manage/provider/products.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/categoryScreen';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    List<String> catagories = Provider.of<Products>(context).categories;
    return Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
        ),
        drawer: MainDrawer(),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blueGrey[200], Colors.white70])),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12, width: 1)),
                padding: EdgeInsets.all(20),
                height: mediaQuery.size.height * .8,
                width: mediaQuery.size.width * .3,
                child: ListView.builder(
                  itemCount: catagories.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          child: SizedBox.expand(
                            child: ElevatedButton(
                              child: Text(catagories[index]),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    ProductsScreen.routeName,
                                    arguments: catagories[index]);
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
            )
            // child: FutureBuilder(
            //   future: Provider.of<Products>(context).fetchAndSetCategories(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return Center(
            //         child: Container(
            //           decoration: BoxDecoration(
            //               color: Colors.white70,
            //               borderRadius: BorderRadius.circular(10),
            //               border: Border.all(color: Colors.black12, width: 1)),
            //           padding: EdgeInsets.all(20),
            //           height: mediaQuery.size.height * .8,
            //           width: mediaQuery.size.width * .3,
            //           child: ListView.builder(
            //             itemCount: snapshot.data.length,
            //             itemBuilder: (context, index) {
            //               return Column(
            //                 children: [
            //                   Container(
            //                     child: SizedBox.expand(
            //                       child: ElevatedButton(
            //                         child: Text(snapshot.data[index]),
            //                         onPressed: () {
            //                           Navigator.of(context).pushNamed(
            //                               ProductsScreen.routeName,
            //                               arguments: snapshot.data[index]);
            //                         },
            //                       ),
            //                     ),
            //                     height: 50,
            //                     width: 300,
            //                     decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(10),
            //                         color: Colors.blueGrey[300],
            //                         border: Border.all(
            //                           width: 1,
            //                           color: Colors.black26,
            //                         )),
            //                   ),
            //                   SizedBox(
            //                     height: 20,
            //                   )
            //                 ],
            //               );
            //             },
            //           ),
            //         ),
            //       );
            //     }
            //     if (snapshot.hasError) {
            //       return Center(
            //         child: Text('something went wrong'),
            //       );
            //     }
            //     return Center(child: CircularProgressIndicator());
            //   },
            // ),
            ));
  }
}
