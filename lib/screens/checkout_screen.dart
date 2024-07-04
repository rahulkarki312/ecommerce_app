import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/consts/text_styles.dart';
import 'package:ecommerce_app/providers/cart.dart';
import 'package:ecommerce_app/providers/product.dart';
import 'package:ecommerce_app/providers/products.dart';
import 'package:ecommerce_app/widgets/custom_button.dart';
import 'package:ecommerce_app/widgets/dropdown_button.dart';
import 'package:ecommerce_app/widgets/order_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatelessWidget {
  static const routeName = '/check-out-screen';
  const CheckOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final products = Provider.of<Products>(context, listen: false);
    const gap = SizedBox(height: 15);
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
          'Order Summary',
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
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
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
              ),
              gap,
              OrderButton(cart: cart, ctx: context),
              gap,
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: [
            const Text('Information', style: AppTextStyles.headline2),
            gap,
            const PaymentDropDown(),
            const LocationDropDown(),
            gap,
            const Text('Order Detail', style: AppTextStyles.headline2),
            ListView.builder(
              itemCount: cart.items.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final cartItem = cart.items.values.toList()[index];
                final cartId = cart.items.keys.toList()[index];
                final product = products.findById(cartId.split(' ').first);

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.title,
                        style: AppTextStyles.headline3,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '${product.brand} ${cartItem.color} Qty ${cartItem.quantity}',
                              style: const TextStyle(
                                  color: CustomColors.greyDark)),
                          Text(
                              '\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700))
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
            gap,
            const Text('Payment Detail', style: AppTextStyles.headline2),
            gap,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sub Total',
                    style: TextStyle(color: CustomColors.greyDark)),
                Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w700))
              ],
            ),
            gap,
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shipping',
                    style: TextStyle(color: CustomColors.greyDark)),
                Text('\$20.00', style: TextStyle(fontWeight: FontWeight.w700))
              ],
            ),
            gap,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Order',
                    style: TextStyle(color: CustomColors.greyDark)),
                Text('\$${(cart.totalAmount + 20).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w700))
              ],
            )
          ],
        ),
      ),
    );
  }
}
