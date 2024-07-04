import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/consts/text_styles.dart';
import 'package:ecommerce_app/providers/cart.dart';
import 'package:ecommerce_app/providers/product.dart';
import 'package:ecommerce_app/providers/userfilter.dart';
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class QuantityRangeField extends StatefulWidget {
  const QuantityRangeField({
    super.key,
    required this.quantityController,
    required this.focusNode,
    required this.loadedProduct,
    required this.cart,
    required this.size,
    required this.color,
    required this.imageUrl,
  });
  final TextEditingController quantityController;
  final FocusNode focusNode;

  final Product loadedProduct;
  final String size;
  final String color;
  final Cart cart;
  final String imageUrl;

  @override
  State<QuantityRangeField> createState() => _QuantityRangeFieldState();
}

class _QuantityRangeFieldState extends State<QuantityRangeField> {
  @override
  void initState() {
    super.initState();
    widget.quantityController.text =
        "1"; // Setting the initial value for the field.
  }

  void showCartNavigationDialog() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: TextFormField(
                  focusNode: widget.focusNode,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                  controller: widget.quantityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: true,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    NoZeroInputFormatter()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  child: SvgPicture.asset(
                    'assets/icons/minus-cirlce.svg',
                    color: widget.quantityController.text == '1'
                        ? CustomColors.grey
                        : null,
                  ),
                  onTap: () {
                    if (widget.quantityController.text == '1') {
                      return;
                    }
                    int currentValue =
                        int.parse(widget.quantityController.text);
                    // widget.filterProvider.selectQuanity(currentValue - 1);

                    setState(() {
                      currentValue--;
                      widget.quantityController.text =
                          (currentValue > 0 ? currentValue : 0)
                              .toString(); // decrementing value
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  child: SvgPicture.asset('assets/icons/add-circle.svg'),
                  onTap: () {
                    int currentValue =
                        int.parse(widget.quantityController.text);
                    // widget.filterProvider.selectQuanity(currentValue + 1);
                    setState(() {
                      currentValue++;
                      widget.quantityController.text =
                          (currentValue).toString(); // incrementing value
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SizedBox(
              height: 55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Price',
                        style: AppTextStyles.caption,
                      ),
                      Text(
                          '\$${widget.loadedProduct.price * int.parse(widget.quantityController.text)}',
                          style: AppTextStyles.headline2)
                    ],
                  ),
                  CustomButton(
                    onTap: () {
                      widget.cart.addItem(
                          widget.loadedProduct.id,
                          widget.loadedProduct.price.toDouble(),
                          widget.loadedProduct.title,
                          widget.color,
                          widget.size,
                          widget.imageUrl,
                          quantity: int.parse(widget.quantityController.text));
                      Navigator.pop(context);

                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            int items =
                                int.parse(widget.quantityController.text);
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(25.0),
                              height: MediaQuery.of(context).size.height * 0.38,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/check.svg',
                                    height: 80,
                                  ),
                                  const Text('Added To Cart',
                                      style: AppTextStyles.headline2),
                                  Text(
                                      '$items item${items > 1 ? 's' : ''} in total'),
                                  SizedBox(
                                    height: 55,
                                    child: Row(
                                      children: [
                                        CustomButton(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          onTap: () {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Added item - ${widget.loadedProduct.title} to cart'),
                                              duration:
                                                  const Duration(seconds: 2),
                                              action: SnackBarAction(
                                                label: "UNDO",
                                                onPressed: () {
                                                  widget.cart.removeSingleItem(
                                                      '${widget.loadedProduct.id} ${widget.color} ${widget.size}');
                                                },
                                              ),
                                            ));
                                          },
                                          isPrimary: false,
                                          reducePadding: true,
                                          child: Text(
                                            'BACK EXPLORE',
                                            style: AppTextStyles.buttonTextStyle
                                                .copyWith(
                                                    color: CustomColors
                                                        .defaultBlack),
                                          ),
                                        ),
                                        CustomButton(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    CartScreen.routeName);
                                          },
                                          isPrimary: true,
                                          child: const Text(
                                            'TO CART',
                                            style:
                                                AppTextStyles.buttonTextStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    isPrimary: true,
                    child: Text(
                      'ADD TO CART',
                      style: AppTextStyles.buttonTextStyle
                          .copyWith(color: CustomColors.defaultWhite),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoZeroInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Filter out '0'
    if (newValue.text.contains('0')) {
      String filteredText = newValue.text.replaceAll('0', '1');
      return TextEditingValue(
        text: filteredText,
        selection: newValue.selection.copyWith(
          baseOffset: filteredText.length,
          extentOffset: filteredText.length,
        ),
      );
    }
    return newValue;
  }
}
