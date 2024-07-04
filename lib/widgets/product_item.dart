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
                      product.imageUrl,
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
                // Positioned(
                //   top: 5,
                //   left: 5,
                //   child: Card(
                //     elevation: 7,
                //     shape: const CircleBorder(),
                //     child: Container(
                //       width: 35,
                //       height: 35,
                //       decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           color: Theme.of(context).primaryColor),
                //       child: Center(
                //         child: IconButton(
                //           icon: Icon(Icons.shopping_cart_outlined,
                //               color: Theme.of(context).colorScheme.secondary),
                //           onPressed: () {
                //             cart.addItem(
                //                 product.id,
                //                 double.parse(product.price.toString()),
                //                 product.title);
                //             ScaffoldMessenger.of(context)
                //                 .hideCurrentSnackBar();
                //             ScaffoldMessenger.of(context)
                //                 .showSnackBar(SnackBar(
                //               content: Text(
                //                   'Added item - ${product.title} to cart'),
                //               duration: Duration(seconds: 2),
                //               action: SnackBarAction(
                //                 label: "UNDO",
                //                 onPressed: () {
                //                   cart.removeSingleItem(product.id);
                //                 },
                //               ),
                //             ));
                //           },
                //           color: Theme.of(context).primaryColorLight,
                //         ),
                //       ),
                //     ),
                //   ),
                // )
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
                      'assets/icons/Star Submit Review.svg', // Path to your SVG asset
                      // Optional: specify color
                      height: 10.0, // Optional: specify height
                    ),
                    Text(
                      ' (11045 Reviews)',
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

                // favorite
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     Text(
                //       "\$${product.price}",
                //       style: const TextStyle(fontWeight: FontWeight.bold),
                //     ),
                // Consumer<Product>(
                //   builder: (ctx, product, _) => IconButton(
                //     icon: Icon(
                //       product.isFavorite
                //           ? Icons.favorite
                //           : Icons.favorite_border,
                //     ),
                //     color: Theme.of(context)
                //         .colorScheme
                //         .secondary, //red for heart
                //     onPressed: () {
                //       product.toggleFavoriteStatus(
                //           authData.token.toString(),
                //           authData.userId.toString());
                //     },
                //   ),
                // ),
                //   ],
                // ),
              ],
            ),
          )
        ],
      ),
    );
    // return ClipRRect(
    //   // borderRadius: BorderRadius.circular(10),
    //   child: Stack(
    //     children: [
    //       GridTile(
    //         child: GestureDetector(
    //           onTap: () {
    //             Navigator.of(context).pushNamed(
    //               ProductDetailScreen.routeName,
    //               arguments: product.id,
    //             );
    //           },
    //           child: Hero(
    //             tag: product.id,
    //             child: Image.network(
    //               product.imageUrl,
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //         ),
    //         footer: GridTileBar(
    //           backgroundColor: Color.fromARGB(170, 0, 0, 0),
    //           title: Column(
    //             children: [
    //               Text(
    //                 product.title,
    //               ),
    //               Text(
    //                 "Rs. " + product.price.toString(),
    //               )
    //             ],
    //           ),
    //           trailing: IconButton(
    //             icon: Icon(
    //               Icons.shopping_cart,
    //               color: Theme.of(context).accentColor,
    //             ),
    // onPressed: () {
    //   cart.addItem(product.id, product.price, product.title);
    //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text('Added item - ${product.title} to cart'),
    //     duration: Duration(seconds: 2),
    //     action: SnackBarAction(
    //       label: "UNDO",
    //       onPressed: () {
    //         cart.removeSingleItem(product.id);
    //       },
    //     ),
    //   ));
    // },
    //             color: Theme.of(context).primaryColorLight,
    //           ),
    //         ),

    //         // GridTileBar(
    //         //   backgroundColor: Color.fromARGB(100, 0, 0, 0),
    //         //   title: Text("Rs." + product.price.toString()),
    //         // )
    //       ),
    //       Positioned(
    //         top: 10,
    //         right: 10,
    //         child: Consumer<Product>(
    //           builder: (ctx, product, _) => IconButton(
    //             icon: Icon(
    //               product.isFavorite ? Icons.favorite : Icons.favorite_border,
    //             ),
    //             color: Theme.of(context).errorColor, //red for heart
    //             onPressed: () {
    //               product.toggleFavoriteStatus(
    //                   authData.token.toString(), authData.userId.toString());
    //             },
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
