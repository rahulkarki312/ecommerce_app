import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/consts/text_styles.dart';
import 'package:ecommerce_app/delegates/search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../providers/products.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _isLoading = false;

  @override
  void initState() {
    setState(() => _isLoading = true);

    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) {
      setState(() => _isLoading = false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(86.0),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          child: AppBar(
            scrolledUnderElevation: 0,
            iconTheme:
                IconThemeData(color: Theme.of(context).colorScheme.secondary),
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text(
              'Discover',
              style: AppTextStyles.headline1,
            ),
            actions: <Widget>[
              Consumer<Cart>(
                builder: (_, cart, ch) => badge(
                  value: cart.itemCount.toString(),
                  child: ch as Widget,
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/bag-2.svg',
                    color: CustomColors.defaultBlack,
                    height: 28.0,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: CustomColors.defaultBlack,
            ))
          : const ProductsGrid(),
    );
  }
}
