import 'package:ecommerce_app/providers/orders.dart';
import 'package:ecommerce_app/providers/products.dart';
import 'package:ecommerce_app/providers/userfilter.dart';
import 'package:ecommerce_app/screens/add_review_screen.dart';
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/screens/checkout_screen.dart';
import 'package:ecommerce_app/screens/list_reviews_screen.dart';
import 'package:ecommerce_app/screens/orders_screen.dart';
import 'package:ecommerce_app/screens/product_detail_screen.dart';
import 'package:ecommerce_app/screens/products_overview_page.dart';
import 'package:ecommerce_app/screens/users_filter_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart.dart';
import 'screens/auth_screen.dart';
import 'providers/auth.dart';
import './screens/loading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (_) => Products("", "", "", []),
              update: (ctx, auth, previousProducts) => Products(
                  auth.token.toString(),
                  auth.userId.toString(),
                  auth.username.toString(),
                  previousProducts == null ? [] : previousProducts.items)),
          ChangeNotifierProvider(create: (_) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders("", "", []),
            update: (ctx, auth, previousOrders) => Orders(
                auth.token.toString(),
                auth.userId.toString(),
                previousOrders == null ? [] : previousOrders.orders),
          ),
          ChangeNotifierProvider(create: (_) => UserFilter()),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.white,
              fontFamily: "Inter",
              colorScheme:
                  ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
            ),
            title: " ",
            home: auth.isAuth
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? const LoadingScreen()
                            : const AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (context) =>
                  const ProductDetailScreen(),
              CartScreen.routeName: (context) => const CartScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              AddReviewScreen.routeName: (context) => const AddReviewScreen(),
              UsersFilterScreen.routeName: (context) =>
                  const UsersFilterScreen(),
              ListReviewsScreen.routeName: (context) =>
                  const ListReviewsScreen(),
              CheckOutScreen.routeName: (context) => const CheckOutScreen()
            },
          ),
        ));
  }
}
