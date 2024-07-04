import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/consts/text_styles.dart';
import 'package:ecommerce_app/screens/checkout_screen.dart';
import 'package:ecommerce_app/widgets/custom_button.dart';
import 'package:ecommerce_app/widgets/order_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      backgroundColor: CustomColors.defaultWhite,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Text(
          'Cart',
          style: AppTextStyles.appBarTitle,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: CustomColors.defaultWhite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Grand Total',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 6),
                  Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: AppTextStyles.headline2)
                ],
              ),
              CustomButton(
                  onTap: () {
                    if (cart.items.isEmpty) {
                      return;
                    }
                    Navigator.of(context)
                        .pushReplacementNamed(CheckOutScreen.routeName);
                  },
                  isPrimary: true,
                  child: const Text(
                    'CHECK OUT',
                    style: AppTextStyles.buttonTextStyle,
                  ))
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            if (cart.items.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) => CartItem(
                      cart.items.keys.toList()[i],
                      cart.items.values.toList()[i].id,
                      cart.items.values.toList()[i].price,
                      cart.items.values.toList()[i].quantity,
                      cart.items.values.toList()[i].title,
                      cart.items.values.toList()[i].color,
                      cart.items.values.toList()[i].size,
                      cart.items.values.toList()[i].imageUrl),
                ),
              ),
            if (cart.items.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your cart is Empty\nContinue Shopping !',
                        style: AppTextStyles.headline2,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 50,
                        color: CustomColors.greyLight,
                      )
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
