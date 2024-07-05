import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/consts/text_styles.dart';
import 'package:ecommerce_app/providers/userfilter.dart';
import 'package:ecommerce_app/screens/users_filter_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final filterProvider = Provider.of<UserFilter>(context);
    final selectedBrand = Provider.of<UserFilter>(context).selectedBrand;

    final products = productsProvider.getFilteredItems(filterProvider);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: <Widget>[
                // Horizontally scrollable brands row
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var brand = productsProvider.brandsAndLogos.keys
                            .toList()[index];
                        bool isSelected = false;
                        if (selectedBrand != null) {
                          isSelected = selectedBrand == brand;
                        }
                        return TextButton(
                          onPressed: () {
                            Provider.of<UserFilter>(context, listen: false)
                                .selectBrand(brand);
                            Provider.of<UserFilter>(context, listen: false)
                                .setFilter();
                          },
                          child: Text(brand,
                              style: AppTextStyles.headline2.copyWith(
                                color: isSelected
                                    ? CustomColors.defaultBlack
                                    : CustomColors.grey,
                              )),
                        );
                      },
                      itemCount: productsProvider.brandsAndLogos.length,
                    ),
                  ),
                ),

                // Vertically scrollable products grid
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return ChangeNotifierProvider.value(
                        value: products[index],
                        child: const ProductItem(),
                      );
                    },
                    childCount: products.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 100,
                  height: 35,
                  child: FloatingActionButton(
                    backgroundColor: CustomColors.defaultBlack,
                    onPressed: () => Navigator.of(context)
                        .pushNamed(UsersFilterScreen.routeName),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/candle-2.svg',
                            height: 14,
                            color: CustomColors.defaultWhite,
                          ),
                          const Text(
                            'FILTER',
                            style: AppTextStyles.buttonTextStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
