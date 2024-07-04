import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/consts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
// OrderItem from providers is not needed since only the data is needed here

import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.defaultWhite,
      appBar: AppBar(
        centerTitle: true,
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
        title: const Text('Orders', style: AppTextStyles.appBarTitle),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return const Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(builder: (ctx, orderData, child) {
                if (orderData.orders.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You have not ordered anything yet',
                          style: AppTextStyles.headline2,
                        ),
                        SizedBox(height: 20),
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 50,
                          color: CustomColors.greyLight,
                        )
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                );
              });
            }
          }
        },
      ),
    );
  }
}
