import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:my_shop/screens/orders_screen.dart';
import 'package:my_shop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friend!'),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).primaryColorDark,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.shop,
              size: 30,
            ),
            title: Text(
              'Shop',
              style: Theme.of(context).textTheme.headline5,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.payment,
              size: 30,
            ),
            title: Text(
              'Orders',
              style: Theme.of(context).textTheme.headline5,
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OredersScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.edit,
              size: 30,
            ),
            title: Text(
              'Manage Products',
              style: Theme.of(context).textTheme.headline5,
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              size: 30,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.headline5,
            ),
            onTap: () {
              // Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
