import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/consts/text_styles.dart';
import 'package:ecommerce_app/providers/userReview.dart';
import 'package:ecommerce_app/providers/userfilter.dart';
import 'package:ecommerce_app/widgets/review_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListReviewsScreen extends StatefulWidget {
  const ListReviewsScreen({super.key});

  static const routeName = '/list-review-screen';
  @override
  _ListReviewsScreenState createState() {
    // TODO: implement createState
    return _ListReviewsScreenState();
  }
}

class _ListReviewsScreenState extends State<ListReviewsScreen> {
  List<ReviewDetails> reviews = [];

  @override
  void didChangeDependencies() {
    reviews = ModalRoute.of(context)!.settings.arguments as List<ReviewDetails>;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<UserFilter>(context);
    final starsSelected = filterProvider.reviewFilter;

    var filteredReviews = reviews;
    if (starsSelected != null) {
      filteredReviews =
          reviews.where((review) => review.rating == starsSelected).toList();
    }
    return Scaffold(
      backgroundColor: CustomColors.defaultWhite,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text(
          'Review (${reviews.length})',
          style: AppTextStyles.appBarTitle,
        ),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/Star Submit Review.svg',
                    height: 13,
                  ),
                  const Text(
                    ' 4.5',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          // Horizontally scrollable reviews filter row
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 20, bottom: 30),
              height: 40,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var stars = index + 1;
                    int? reviewFilter = filterProvider.reviewFilter;
                    bool isSelected = false;
                    if (index == 0) {
                      // Handle the 'All' button
                      isSelected = reviewFilter == null;
                      return TextButton(
                        onPressed: () => filterProvider.setReviewFilter(null),
                        child: Text(
                          'All',
                          style: AppTextStyles.headline2.copyWith(
                            color: isSelected
                                ? CustomColors.defaultBlack
                                : CustomColors.grey,
                          ),
                        ),
                      );
                    } else {
                      // Handle the star buttons
                      var stars = 6 - index; // Descending from 5 to 1
                      isSelected = stars == reviewFilter;
                      return TextButton(
                        onPressed: () => filterProvider.setReviewFilter(stars),
                        child: Text(
                          '$stars Star${stars > 1 ? 's' : ''}',
                          style: AppTextStyles.headline2.copyWith(
                            color: isSelected
                                ? CustomColors.defaultBlack
                                : CustomColors.grey,
                          ),
                        ),
                      );
                    }
                  },
                  itemCount: 6),
            ),
          ),

          // Vertically scrollable reviews grid
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              height: MediaQuery.of(context).size.height * 0.9,
              child: ListView.builder(
                  itemBuilder: (context, index) =>
                      ReviewItem(review: filteredReviews[index]),
                  itemCount: filteredReviews.length),
            ),
          ),
        ],
      ),
    );
  }
}
