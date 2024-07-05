// import 'dart:convert';
import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/providers/userReview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserFilter with ChangeNotifier {
  String? pickedColor;
  String selectedBrand = 'All';
  double priceLow = 100;
  double priceHigh = 750;

  String? selectedGender;
  String? sortByOption;

  String? pickedShoeColor;
  String? pickedSize;
  int? reviewFilter;

  num selectedQuantity = 1;

  List<String> sortByOptions = [
    'Most Recent',
    'Lowest Price',
    'Highest Review'
  ];

  List<String> genderOptions = ['Man', 'Woman', 'Unisex'];

  List<String> colorOptions = [
    'Black',
    'White',
    'Green',
    'Red',
    'Blue',
    'Purple'
  ];

  Color getColorFromOption(String option) {
    switch (option) {
      case 'Red':
        return CustomColors.trashColor;
      case 'Green':
        return Colors.green;
      case 'Blue':
        return Colors.blue;
      case 'White':
        return CustomColors.defaultWhite;
      case 'Purple':
        return Colors.purple;
      case 'Black':
        return CustomColors.defaultBlack;
      case 'Aqua':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  void setReviewFilter(int? stars) {
    reviewFilter = stars;
    notifyListeners();
  }

  void selectBrand(String brand) {
    selectedBrand = brand;
    if (brand == 'All') {
      resetFilter();
    }
  }

  void pickColor(String color) {
    if (color == pickedColor) {
      pickedColor = null;
    } else {
      pickedColor = color;
    }
    notifyListeners();
  }

  void pickShoeColor(String color) {
    pickedShoeColor = color;
    notifyListeners();
  }

  void pickShoeSize(String size) {
    pickedSize = size;
    notifyListeners();
  }

  void setPriceRange(double low, double high) {
    priceLow = low;
    priceHigh = high;
    // isSliderChanged = true;
    notifyListeners();
  }

  void selectGender(String gender) {
    if (selectedGender == gender) {
      selectedGender = null;
    } else {
      selectedGender = gender;
    }
    notifyListeners();
  }

  void selectQuanity(int quantity) {
    selectedQuantity = quantity;

    notifyListeners();
  }

  void sortBy(String option) {
    if (option == sortByOption) {
      sortByOption = null;
    } else {
      sortByOption = option;
    }
    notifyListeners();
  }

  void setFilter() {
    // update and set filter
    notifyListeners();
  }

  void resetFilter({bool resetColorFilter = true}) {
    if (resetColorFilter) {
      pickedColor = null;
    }
    selectedBrand = 'All';
    priceLow = 100;
    priceHigh = 750;
    selectedGender = null;
    sortByOption = null;

    notifyListeners();
  }

  int get changes {
    int changesCount = 0;
    if (selectedBrand != 'All') {
      changesCount++;
    }
    if (pickedColor != null) {
      changesCount++;
    }
    if (priceLow != 100 || priceHigh != 750) {
      changesCount++;
    }
    if (sortByOption != null) {
      changesCount++;
    }
    if (selectedGender != null) {
      changesCount++;
    }
    return changesCount;
  }
}
