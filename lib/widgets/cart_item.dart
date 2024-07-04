import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/consts/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final String color;
  final String size;
  final String imageUrl;

  const CartItem(this.id, this.productId, this.price, this.quantity, this.title,
      this.color, this.size, this.imageUrl,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false);
    final product = products.findById(id.split(' ').first);
    final cart = Provider.of<Cart>(context);

    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: SvgPicture.asset(
          'assets/icons/trash.svg',
          color: Colors.white,
          height: 25,
        ),
      ),
      confirmDismiss: (direction) => showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Are you sure?"),
                content:
                    const Text("Do you want to delete item from the cart?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("No")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("Yes"))
                ],
              )),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                      color: CustomColors.greyLightest,
                      borderRadius: BorderRadius.circular(18)),
                ),
                SizedBox(
                  height: 65,
                  width: 65,
                  child: Center(
                    child: Image.network(
                      imageUrl,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    product.title,
                    style: AppTextStyles.headline3,
                  ),
                  Text(
                    '${product.brand}     $size      $color',
                    style: AppTextStyles.caption
                        .copyWith(color: CustomColors.grey),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${(product.price * quantity).toStringAsFixed(2)}',
                          style: AppTextStyles.headline3,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  if (quantity > 1) {
                                    cart.decreaseProductQuantity(id);
                                  }
                                },
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: SvgPicture.asset(
                                    'assets/icons/minus-cirlce.svg',
                                    height: 15,
                                    color: quantity == 1
                                        ? CustomColors.grey
                                        : null,
                                  ),
                                )),
                            Text('  ${quantity.toString()}  '),
                            GestureDetector(
                                onTap: () {
                                  cart.increaseProductQuantity(id);
                                },
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: SvgPicture.asset(
                                    'assets/icons/add-circle.svg',
                                    height: 15,
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
