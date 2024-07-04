import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/consts/text_styles.dart';
import 'package:ecommerce_app/providers/cart.dart';
import 'package:ecommerce_app/providers/orders.dart';
import 'package:ecommerce_app/screens/checkout_screen.dart';
import 'package:ecommerce_app/screens/products_overview_page.dart';
import 'package:ecommerce_app/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderButton extends StatefulWidget {
  final Cart cart;
  final BuildContext ctx;

  const OrderButton({
    Key? key,
    required this.cart,
    required this.ctx,
  }) : super(key: key);

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      isPrimary: true,
      onTap: () async {
        if ((widget.cart.totalAmount > 0 || !_isLoading)) {
          setState(() {
            _isLoading = true;
          });

          await Provider.of<Orders>(context, listen: false).addOrder(
            widget.cart.items.values.toList(),
            widget.cart.totalAmount,
          );

          setState(() {
            _isLoading = false;
          });
          widget.cart.clear();
          Navigator.of(context).pushReplacementNamed('/');
        }
      },
      child: _isLoading
          ? const SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: CustomColors.defaultWhite,
              ))
          : const Text(
              'PAYMENT',
              style: AppTextStyles.buttonTextStyle,
            ),
    );
  }
}
