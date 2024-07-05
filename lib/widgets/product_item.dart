import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/consts/text_styles.dart';
import 'package:ecommerce_app/providers/userfilter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final filterProvider = Provider.of<UserFilter>(context);
    final pickedColor = filterProvider.pickedColor;

    final authData = Provider.of<Auth>(context, listen: false);
    return GestureDetector(
      onTap: () {
        filterProvider.pickShoeColor(product.colorImages.keys.toList()[0]);
        filterProvider
            .pickShoeSize(product.sizes.isEmpty ? '' : product.sizes[0]);
        Navigator.of(context).pushNamed(
          ProductDetailScreen.routeName,
          arguments: product.id,
        );
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: CustomColors.greyLightest,
                      borderRadius: BorderRadius.circular(12)),
                ),
                Center(
                  child: Hero(
                    tag: product.id,
                    child: Image.network(
                      height: MediaQuery.of(context).size.height * 0.13,
                      // product.imageUrl,
                      product.colorImages[pickedColor ??
                              product.colorImages.keys.toList()[0]]
                          .toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 15,
                  child: SvgPicture.asset(
                    'assets/icons/Name=${product.brand}, Color=Grey.svg',
                    height: 26.0,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/Star Submit Review.svg',
                      height: 10.0,
                    ),
                    Text(
                      ' (${product.reviews.length} Reviews)',
                      style: const TextStyle(
                          fontSize: 9.0, color: CustomColors.grey),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "\$${product.price}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
