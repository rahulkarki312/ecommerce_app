import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/consts/text_styles.dart';
import 'package:ecommerce_app/providers/products.dart';
import 'package:ecommerce_app/providers/userfilter.dart';
import 'package:ecommerce_app/widgets/custom_button.dart';
import 'package:ecommerce_app/widgets/price_range_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class UsersFilterScreen extends StatefulWidget {
  const UsersFilterScreen({super.key});
  static const routeName = '/users-filter-screen';
  @override
  State<UsersFilterScreen> createState() => _UsersFilterScreenState();
}

class _UsersFilterScreenState extends State<UsersFilterScreen> {
  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<UserFilter>(context);
    final productsProvider = Provider.of<Products>(context);
    final Map<String, String> brandsAndLogos = productsProvider.brandsAndLogos;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              filterProvider.resetFilter(resetColorFilter: false);
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Text(
          'Filter',
          style: AppTextStyles.appBarTitle,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomButton(
              width: MediaQuery.of(context).size.width * 0.4,
              onTap: () => filterProvider.resetFilter(),
              isPrimary: false,
              child: Text(
                'RESET (${filterProvider.changes})',
                style: AppTextStyles.buttonTextStyle
                    .copyWith(color: CustomColors.defaultBlack),
              ),
            ),
            CustomButton(
              width: MediaQuery.of(context).size.width * 0.4,
              onTap: () {
                filterProvider.setFilter();
                Navigator.pop(context);
              },
              isPrimary: true,
              child: const Text(
                'APPLY',
                style: AppTextStyles.buttonTextStyle,
              ),
            )
          ],
        ),
      ),
      body: Container(
        color: CustomColors.defaultWhite,
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Brands', style: AppTextStyles.headline3),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              height: 125,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: brandsAndLogos.length - 1,
                itemBuilder: (context, index) {
                  String brandName = brandsAndLogos.keys.toList()[index + 1];
                  String brandLogo = brandsAndLogos.values.toList()[index + 1];
                  bool isSelected = filterProvider.selectedBrand == brandName;
                  return InkWell(
                    onTap: () {
                      filterProvider.selectBrand(brandName);
                      filterProvider.setFilter();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: CustomColors.greyLight,
                                child: SvgPicture.asset(
                                  brandLogo,
                                  color: CustomColors.defaultBlack,
                                ),
                              ),
                              if (isSelected)
                                const Positioned(
                                    bottom: -1,
                                    right: 0,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: CustomColors.defaultBlack,
                                      size: 18,
                                    ))
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            brandName,
                            style:
                                AppTextStyles.headline3.copyWith(fontSize: 13),
                          ),
                          const Text(
                            '1001 items',
                            style: AppTextStyles.hintTextStyle,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Text(
              'Price Range',
              style: AppTextStyles.headline3,
            ),
            PriceRangeSlider(
              priceLow: 0,
              priceHigh: 1000,
              ctx: context,
            ),
            const Text(
              'Sort By',
              style: AppTextStyles.headline3,
            ),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                height: 70,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filterProvider.sortByOptions.length,
                    itemBuilder: (context, index) {
                      String option = filterProvider.sortByOptions[index];
                      bool isSelected = false;
                      if (filterProvider.sortByOption != null) {
                        isSelected = option == filterProvider.sortByOption;
                      }

                      return CustomButton(
                        onTap: () => filterProvider.sortBy(option),
                        isPrimary: isSelected,
                        isSmallButton: true,
                        child: Text(
                          option,
                          style: AppTextStyles.buttonTextStyle.copyWith(
                              color: isSelected
                                  ? CustomColors.defaultWhite
                                  : CustomColors.defaultBlack),
                        ),
                      );
                    })),
            const Text(
              'Gender',
              style: AppTextStyles.headline3,
            ),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                height: 70,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filterProvider.genderOptions.length,
                    itemBuilder: (context, index) {
                      String gender = filterProvider.genderOptions[index];
                      bool isSelected = false;
                      if (filterProvider.selectedGender != null) {
                        isSelected = gender == filterProvider.selectedGender;
                      }
                      return CustomButton(
                        onTap: () => filterProvider.selectGender(gender),
                        isPrimary: isSelected,
                        isSmallButton: true,
                        child: Text(
                          gender,
                          style: AppTextStyles.buttonTextStyle.copyWith(
                              color: isSelected
                                  ? CustomColors.defaultWhite
                                  : CustomColors.defaultBlack),
                        ),
                      );
                    })),
            const Text(
              'Colors',
              style: AppTextStyles.headline3,
            ),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filterProvider.colorOptions.length,
                  itemBuilder: (context, index) {
                    String color = filterProvider.colorOptions[index];
                    bool isSelected = false;
                    if (filterProvider.pickedColor != null) {
                      isSelected = filterProvider.pickedColor == color;
                    }
                    return CustomButton(
                      changeOverlay: false,
                      isSmallButton: true,
                      onTap: () => filterProvider.pickColor(color),
                      isPrimary: isSelected,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 9,
                            backgroundColor: CustomColors.greyLight,
                            child: CircleAvatar(
                              backgroundColor:
                                  filterProvider.getColorFromOption(color),
                              radius: 8,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            color,
                            style: AppTextStyles.buttonTextStyle
                                .copyWith(color: CustomColors.defaultBlack),
                          ),
                        ],
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
