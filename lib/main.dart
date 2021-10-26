import 'package:flutter/material.dart';
import 'package:my_shop/helpers/custom_route.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/auth_screen.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/screens/orders_screen.dart';
import 'package:my_shop/screens/product_detail_screen.dart';
import 'package:my_shop/screens/products_overview.dart';
import 'package:my_shop/screens/splash_screen.dart';
import 'package:my_shop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget isLoggedInScreen(Auth auth, Widget screen) {
    return auth.isAuth ? screen : const AuthScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(),
          update: (ctx, auth, previousProducts) => Products.auth(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(),
          update: (ctx, auth, previousOrders) => Orders.auth(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                  headline5: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
            primarySwatch: Colors.purple,
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  secondary: Colors.deepOrange,
                ),
            fontFamily: 'Lato',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.purple,
            ),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
          ),
          home: auth.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          debugShowCheckedModeBanner: false,
          routes: {
            ProductDetailScreen.routeName: (ctx) => isLoggedInScreen(
                  auth,
                  const ProductDetailScreen(),
                ),
            CartScreen.routeName: (ctx) => isLoggedInScreen(
                  auth,
                  const CartScreen(),
                ),
            OredersScreen.routeName: (ctx) => isLoggedInScreen(
                  auth,
                  const OredersScreen(),
                ),
            UserProductsScreen.routeName: (ctx) => isLoggedInScreen(
                  auth,
                  const UserProductsScreen(),
                ),
            EditProduct.routeName: (ctx) => isLoggedInScreen(
                  auth,
                  const EditProduct(),
                ),
            AuthScreen.routeName: (ctx) => isLoggedInScreen(
                  auth,
                  const AuthScreen(),
                ),
          },
        ),
      ),
    );
  }
}
