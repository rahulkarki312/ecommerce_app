import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/consts/text_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isPrimary;
  final Widget child;
  final bool thickPadding;
  final double? width;
  final bool isSmallButton;
  final bool changeOverlay;
  final bool reducePadding;

  CustomButton({
    required this.onTap,
    required this.isPrimary,
    required this.child,
    this.width,
    this.thickPadding = false,
    this.isSmallButton = false,
    this.changeOverlay = true,
    this.reducePadding = false,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = reducePadding ? 10.0 : 40.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: isSmallButton ? 50 : null,
          width: width,
          margin: EdgeInsets.symmetric(
              vertical: isSmallButton ? 10 : 5, horizontal: 5),
          padding: EdgeInsets.symmetric(
              horizontal: isSmallButton ? 12 : horizontalPadding,
              vertical: thickPadding ? 12 : 0),
          decoration: BoxDecoration(
            color: isPrimary && changeOverlay
                ? CustomColors.defaultBlack
                : CustomColors.defaultWhite,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isPrimary
                  ? CustomColors.defaultBlack
                  : CustomColors.greyLight,
              width: 1,
            ),
          ),
          child: Center(
            child: child,
          )),
    );
  }
}
