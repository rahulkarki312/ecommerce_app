import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:flutter/material.dart';

class badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;

  const badge({
    super.key,
    required this.child,
    required this.value,
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        if (value != '0')
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2.0),
              // color: Theme.of(context).accentColor,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: color,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 10, color: CustomColors.defaultWhite),
              ),
            ),
          )
      ],
    );
  }
}
