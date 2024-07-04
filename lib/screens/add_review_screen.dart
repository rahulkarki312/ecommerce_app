import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/consts/text_styles.dart';
import 'package:ecommerce_app/providers/product.dart';
import 'package:ecommerce_app/providers/products.dart';
import 'package:ecommerce_app/widgets/custom_button.dart';
import 'package:ecommerce_app/widgets/review_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});
  static const routeName = '/add-reviews-screen';
  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  String? productId;
  Product? product;

  @override
  void didChangeDependencies() {
    productId = ModalRoute.of(context)!.settings.arguments.toString();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (productId != 'null') {
      product =
          Provider.of<Products>(context, listen: false).findById(productId);
    }

    return Scaffold(
        backgroundColor: CustomColors.defaultWhite,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Write A Review',
            style: AppTextStyles.appBarTitle,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Leave a review and rating for',
              style: AppTextStyles.headline3,
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                product!.title,
                style: AppTextStyles.headline2,
              ),
            ),
            const SizedBox(height: 30),
            _ReviewCard(productId: productId!),
            const SizedBox(height: 30),
          ],
        ));
  }
}

class _ReviewCard extends StatefulWidget {
  _ReviewCard({
    super.key,
    required this.productId,
  });

  String productId;

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _reviewFormIsLoading = false;
  final _reviewNode = FocusNode();
  final _ratingNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  double _ratingController = 1;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    print('saving');
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _reviewFormIsLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .addReview(_reviewController.text, _ratingController, widget.productId)
        .then((value) {
      setState(() {
        _reviewFormIsLoading = false;
      });
      _reviewController.clear();
      _ratingController = 1;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _reviewController,
                      focusNode: _reviewNode,
                      decoration: const InputDecoration(labelText: 'Review'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_ratingNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Review';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('How would you rate them?'),
                    const SizedBox(
                      height: 20,
                    ),
                    RatingBar.builder(
                      initialRating: 1,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => SvgPicture.asset(
                          'assets/icons/Star Submit Review.svg'),
                      onRatingUpdate: (rating) {
                        _ratingController = rating;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _reviewFormIsLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            onTap: () => _saveForm(),
                            isPrimary: true,
                            thickPadding: true,
                            child: const Text(
                              'Submit',
                              style: AppTextStyles.buttonTextStyle,
                            ))
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
