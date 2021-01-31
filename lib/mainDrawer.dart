import './Screens/customersScreen.dart';

import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blueGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            BuildListTile(
              icon: Icons.home,
              text: 'HomePage',
              tapHandler: () {
                print('pressed');
                Navigator.of(context).pushNamed('/');
              },
            ),
            Divider(),
            SizedBox(
              height: 20,
            ),
            BuildListTile(
              icon: Icons.person_search,
              text: 'Customers',
              tapHandler: () {
                Navigator.of(context).pushNamed(CustomersScreen.routeName);
              },
            ),
            Divider(),
            SizedBox(
              height: 20,
            ),
            BuildListTile(icon: Icons.money, text: 'Transaction History'),
            Divider(),
            SizedBox(
              height: 20,
            ),
            BuildListTile(icon: Icons.notifications, text: 'Daily Check'),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class BuildListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function tapHandler;
  BuildListTile({this.icon, this.text, this.tapHandler});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 20, right: 50),
      leading: Icon(icon),
      trailing: Text(text),
      onTap: tapHandler,
    );
  }
}
