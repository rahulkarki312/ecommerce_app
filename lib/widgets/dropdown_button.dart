import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentDropDown extends StatefulWidget {
  const PaymentDropDown({super.key});

  @override
  State<PaymentDropDown> createState() => _PaymentDropDownState();
}

class _PaymentDropDownState extends State<PaymentDropDown> {
  String? _selectedPaymentOption = 'Credit Card';

  final List<String> _paymentOptions = [
    'Credit Card',
    'PayPal',
    'Apple Pay',
    'Google Pay',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      icon: const Icon(
        Icons.chevron_right_sharp,
      ),
      value: _selectedPaymentOption,
      hint: const Text('Select Payment Method'),
      items: _paymentOptions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedPaymentOption = newValue;
        });
      },
    );
  }
}

class LocationDropDown extends StatefulWidget {
  const LocationDropDown({super.key});

  @override
  State<LocationDropDown> createState() => _LocationDropDownState();
}

class _LocationDropDownState extends State<LocationDropDown> {
  String? _selectedLocation = 'France';

  final List<String> _locations = [
    'France',
    'Germany',
    'Italy',
    'Spain',
    'United Kingdom',
    'Netherlands',
    'Belgium',
    'Sweden',
    'Norway',
    'Denmark',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      icon: const Icon(
        Icons.chevron_right_sharp,
      ),
      value: _selectedLocation,
      hint: const Text('Select Payment Method'),
      items: _locations.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedLocation = newValue;
        });
      },
    );
  }
}
