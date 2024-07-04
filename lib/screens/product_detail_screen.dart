import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/consts/text_styles.dart';
import 'package:ecommerce_app/providers/userfilter.dart';
import 'package:ecommerce_app/screens/add_review_screen.dart';

import 'package:ecommerce_app/screens/list_reviews_screen.dart';
import 'package:ecommerce_app/widgets/badge.dart';
import 'package:ecommerce_app/widgets/custom_button.dart';
import 'package:ecommerce_app/widgets/quantity_range_field.dart';
import 'package:ecommerce_app/widgets/review_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './cart_screen.dart';
import '../providers/cart.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  @override
  void initState() {
    _focusNode = FocusNode();

    // Listen to focus changes
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final cart = Provider.of<Cart>(context, listen: false);
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    final filterProvider = Provider.of<UserFilter>(context);
    final pickedShoeColor = filterProvider.pickedShoeColor;
    TextEditingController quantityController = TextEditingController(text: '1');
    const gap = SizedBox(height: 10);
    const bigGap = SizedBox(height: 20);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: Container(
          margin:
              const EdgeInsets.only(top: 20, bottom: 0, left: 18, right: 18),
          child: AppBar(
            scrolledUnderElevation: 0,
            iconTheme:
                IconThemeData(color: Theme.of(context).colorScheme.secondary),
            backgroundColor: CustomColors.defaultWhite,
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
                    'Price',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 6),
                  Text('\$${loadedProduct.price}',
                      style: AppTextStyles.headline2)
                ],
              ),
              CustomButton(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) => Container(
                            height: _isFocused &&
                                    MediaQuery.of(context).viewInsets.bottom > 0
                                ? MediaQuery.of(context).size.height * 0.6
                                : MediaQuery.of(context).size.height * 0.38,
                            width: double.infinity,
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Add To Cart',
                                      style: AppTextStyles.headline2,
                                    ),
                                    IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: const Icon(Icons.close))
                                  ],
                                ),
                                const SizedBox(height: 20),
                                QuantityRangeField(
                                  color: filterProvider.pickedShoeColor!,
                                  imageUrl: loadedProduct
                                      .colorImages[pickedShoeColor],
                                  size: filterProvider.pickedSize!,
                                  quantityController: quantityController,
                                  focusNode: _focusNode,
                                  loadedProduct: loadedProduct,
                                  cart: cart,
                                ),
                                bigGap,
                              ],
                            ),
                          ));
                },
                isPrimary: true,
                child: const Text(
                  'ADD TO CART',
                  style: AppTextStyles.buttonTextStyle,
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.40,
                    decoration: BoxDecoration(
                        color: CustomColors.greyLightest,
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40,
                    child: Center(
                      child: Hero(
                        tag: loadedProduct.id,
                        child: Image.network(
                          loadedProduct.colorImages[pickedShoeColor],
                          height: MediaQuery.of(context).size.height * 0.25,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 15,
                      right: 15,
                      child: Card(
                        color: CustomColors.defaultWhite,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Adjust as needed
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 7.0, horizontal: 10.0),
                          child: Row(
                            children:
                                loadedProduct.colorImages.entries.map((entry) {
                              final color =
                                  filterProvider.getColorFromOption(entry.key);

                              bool isSelected =
                                  entry.key == filterProvider.pickedShoeColor;

                              return InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  filterProvider.pickShoeColor(entry.key);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: CustomColors.greyLight,
                                        radius: 11,
                                        child: CircleAvatar(
                                          backgroundColor: color,
                                          radius: 10,
                                        ),
                                      ),
                                      if (isSelected)
                                        Positioned(
                                          bottom: 3,
                                          left: 2,
                                          child: Icon(
                                            size: 18,
                                            Icons.check,
                                            color: entry.key == 'White'
                                                ? CustomColors.grey
                                                : CustomColors.defaultWhite,
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )),
                ],
              ),
              gap,
              Text(
                loadedProduct.title,
                style: AppTextStyles.headline2,
              ),
              gap,
              Row(
                children: [
                  ...List.generate(
                      5,
                      (index) => SvgPicture.asset(
                          'assets/icons/Star Submit Review.svg')),
                  const Text(
                    ' 5',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 10.0),
                  ),
                  const Text(
                    ' (11045 Reviews)',
                    style: TextStyle(fontSize: 10.0, color: CustomColors.grey),
                  )
                ],
              ),
              bigGap,
              const Text(
                'Size',
                style: AppTextStyles.headline3,
              ),
              gap,
              SizedBox(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: loadedProduct.sizes.length,
                  itemBuilder: (context, index) {
                    String? selectedSize = filterProvider.pickedSize;
                    bool isSelected = false;
                    if (selectedSize != null) {
                      isSelected = selectedSize == loadedProduct.sizes[index];
                    }

                    return InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => filterProvider
                          .pickShoeSize(loadedProduct.sizes[index]),
                      child: CircleAvatar(
                        radius: 23,
                        backgroundColor: CustomColors.greyLight,
                        child: CircleAvatar(
                            radius: 21,
                            backgroundColor: isSelected
                                ? CustomColors.defaultBlack
                                : CustomColors.defaultWhite,
                            child: Text(
                              loadedProduct.sizes[index],
                              style: AppTextStyles.caption.copyWith(
                                color: isSelected
                                    ? CustomColors.defaultWhite
                                    : CustomColors.defaultBlack,
                              ),
                            )),
                      ),
                    );
                  },
                ),
              ),
              gap,
              const Text(
                'Description',
                style: AppTextStyles.headline3,
              ),
              gap,
              SizedBox(
                width: double.infinity,
                child: Text(
                  loadedProduct.description,
                  softWrap: true,
                  style: AppTextStyles.caption,
                ),
              ),
              bigGap,
              Text(
                'Review (${loadedProduct.reviews.length})',
                style: AppTextStyles.headline3,
              ),
              gap,
              if (loadedProduct.reviews.isNotEmpty)
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: loadedProduct.reviews.length >= 3
                        ? 3
                        : loadedProduct.reviews.length,
                    itemBuilder: (context, index) =>
                        ReviewItem(review: loadedProduct.reviews[index]),
                  ),
                ),
              if (loadedProduct.reviews.isEmpty)
                const SizedBox(
                    height: 25,
                    child: Text(
                      'No Reviews Yet',
                      style: AppTextStyles.caption,
                    )),
              bigGap,
              CustomButton(
                thickPadding: true,
                onTap: () => Navigator.of(context)
                    .pushNamed(AddReviewScreen.routeName, arguments: productId),
                isPrimary: true,
                child: const Text('WRITE A REVIEW',
                    style: AppTextStyles.buttonTextStyle),
              ),
              CustomButton(
                thickPadding: true,
                onTap: () {
                  if (loadedProduct.reviews.isNotEmpty) {
                    Navigator.of(context).pushNamed(ListReviewsScreen.routeName,
                        arguments: loadedProduct.reviews);
                  }
                },
                isPrimary: false,
                child: Text(
                  'SEE ALL REVIEW',
                  style: AppTextStyles.buttonTextStyle
                      .copyWith(color: CustomColors.defaultBlack),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
