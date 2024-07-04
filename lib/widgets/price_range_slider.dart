import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/providers/userfilter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

// class PriceRangeSlider extends StatefulWidget {
//   const PriceRangeSlider(
//       {super.key,
//       required this.priceLow,
//       required this.priceHigh,
//       required this.ctx});
//   final double priceLow;
//   final double priceHigh;
//   final BuildContext ctx;

//   @override
//   State<PriceRangeSlider> createState() => _PriceRangeSliderState();
// }

// class _PriceRangeSliderState extends State<PriceRangeSlider> {
//   SfRangeValues _values = SfRangeValues(200.0, 750.0);

//   @override
//   Widget build(BuildContext context) {
//     // SfRangeValues _values = SfRangeValues(200.0, 750.0);
//     return Padding(
//       padding: const EdgeInsets.only(top: 15, bottom: 25),
//       child: SfRangeSliderTheme(
//         data: SfRangeSliderThemeData(
//           activeTrackHeight: 3,
//           inactiveTrackHeight: 2,
//           activeTrackColor: CustomColors.defaultBlack,
//           thumbColor: CustomColors.defaultWhite,
//           thumbRadius: 9,
//           thumbStrokeWidth: 4,
//           thumbStrokeColor: CustomColors.defaultBlack,
//           tooltipBackgroundColor: CustomColors.defaultBlack,
//           tooltipTextStyle: const TextStyle(fontSize: 10),
//           activeLabelStyle: const TextStyle(
//               fontSize: 12,
//               color: CustomColors.defaultBlack,
//               fontWeight: FontWeight.w700),
//           inactiveLabelStyle: const TextStyle(
//               fontSize: 12,
//               color: CustomColors.defaultBlack,
//               fontWeight: FontWeight.w700),
//         ),
//         child: SfRangeSlider(
//           inactiveColor: CustomColors.greyLight,
//           min: widget.priceLow,
//           max: widget.priceHigh,
//           enableTooltip: true,
//           tooltipShape: const SfPaddleTooltipShape(),
//           values: _values,
//           interval: 500,
//           showTicks: false,
//           showLabels: true,
//           numberFormat: NumberFormat("\$"),
//           onChanged: (SfRangeValues values) {
//             // print('new values: $values');
//             setState(() {
//               _values = values;
//             });
//             Provider.of<UserFilter>(widget.ctx, listen: false)
//                 .setPriceRange(values.start, values.end);
//           },
//         ),
//       ),
//     );
//   }
// }

class PriceRangeSlider extends StatelessWidget {
  final double priceLow;
  final double priceHigh;
  final BuildContext ctx;
  const PriceRangeSlider(
      {super.key,
      required this.priceLow,
      required this.priceHigh,
      required this.ctx});

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<UserFilter>(ctx);
    SfRangeValues values =
        SfRangeValues(filterProvider.priceLow, filterProvider.priceHigh);

    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 30),
      child: SfRangeSliderTheme(
        data: SfRangeSliderThemeData(
          activeTrackHeight: 3,
          inactiveTrackHeight: 2,
          activeTrackColor: CustomColors.defaultBlack,
          thumbColor: CustomColors.defaultWhite,
          thumbRadius: 9,
          thumbStrokeWidth: 4,
          thumbStrokeColor: CustomColors.defaultBlack,
          tooltipBackgroundColor: CustomColors.defaultBlack,
          tooltipTextStyle: const TextStyle(fontSize: 10),
          activeLabelStyle: const TextStyle(
              fontSize: 12,
              color: CustomColors.defaultBlack,
              fontWeight: FontWeight.w700),
          inactiveLabelStyle: const TextStyle(
              fontSize: 12,
              color: CustomColors.defaultBlack,
              fontWeight: FontWeight.w700),
        ),
        child: SfRangeSlider(
          inactiveColor: CustomColors.greyLight,
          min: priceLow,
          max: priceHigh,
          enableTooltip: true,
          tooltipShape: const SfPaddleTooltipShape(),
          values: values,
          interval: 250,
          showTicks: false,
          showLabels: true,
          numberFormat: NumberFormat("\$"),
          onChanged: (SfRangeValues values) {
            Provider.of<UserFilter>(ctx, listen: false)
                .setPriceRange(values.start, values.end);
          },
        ),
      ),
    );
  }
}
