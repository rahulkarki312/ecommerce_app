import 'dart:math';

import 'package:ecommerce_app/consts/app_colors.dart';
import 'package:ecommerce_app/consts/text_styles.dart';
import 'package:ecommerce_app/providers/auth.dart';
import 'package:ecommerce_app/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/userReview.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewItem extends StatelessWidget {
  final ReviewDetails review;
  const ReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 7),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: CustomColors.greyLight,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.height * 0.12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    review.username,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Text(DateFormat('d MMMM, yyyy').format(review.date),
                      style: AppTextStyles.caption.copyWith(
                        color: CustomColors.grey,
                      ))
                ],
              ),
              RatingBarIndicator(
                rating: review.rating,
                itemBuilder: (ctx, idx) => SvgPicture.asset(
                  'assets/icons/Star Submit Review.svg',
                ),
                itemCount: 5,
                itemSize: 10,
                direction: Axis.horizontal,
              ),
              Text(
                textAlign: TextAlign.start,
                review.review,
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 15)
            ],
          ),
        ),
      ],
    );
  }
}

// class ReviewItem extends StatelessWidget {
//   final String productId;
//   bool? showOnly;
//   ReviewItem({required this.productId, this.showOnly = false});

//   @override
//   Widget build(BuildContext context) {
//     ReviewDetails review = Provider.of<ReviewDetails>(context);
//     final currentUser = Provider.of<Auth>(context).userId;
//     final reviewByUser = review.userId;
//     return Container(
//       constraints: BoxConstraints(
//           maxWidth: showOnly!
//               ? MediaQuery.of(context).size.width * 0.8
//               : MediaQuery.of(context).size.width * 0.9),
//       child: Card(
//         margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
//         child: ListTile(
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 RichText(
//                   text: TextSpan(
//                     // Note: Styles for TextSpans must be explicitly defined.
//                     // Child text spans will inherit styles from parent
//                     style: TextStyle(
//                       fontSize: showOnly! ? 15 : 17,
//                       color: Colors.black,
//                       fontFamily: "Montserrat",
//                     ),
//                     children: <TextSpan>[
//                       TextSpan(
//                           text: " ${review.username}: ",
//                           style: const TextStyle(fontWeight: FontWeight.w700)),
//                       TextSpan(text: review.review),
//                     ],
//                   ),
//                 ),
//                 // Text(
//                 //   '${review.username}: ${review.review}',
//                 //   style: TextStyle(fontSize: showOnly! ? 15 : 17),
//                 // ),
//                 RatingBarIndicator(
//                   rating: review.rating,
//                   itemBuilder: (ctx, idx) => Icon(
//                     showOnly! ? Icons.circle : Icons.star,
//                     color: showOnly! ? Colors.black : Colors.amber,
//                   ),
//                   itemCount: 5,
//                   itemSize: showOnly! ? 15 : 20,
//                   direction: Axis.horizontal,
//                 )
//               ],
//             ),
//             subtitle:
//                 showOnly! ? null : Text(DateFormat.yMd().format(review.date)),
//             trailing: showOnly!
//                 ? null
//                 : currentUser == reviewByUser
//                     ? IconButton(
//                         onPressed: () =>
//                             Provider.of<Products>(context, listen: false)
//                                 .removeReview(review.id, productId),
//                         icon: const Icon(
//                           Icons.delete,
//                           color: Colors.red,
//                         ))
//                     : Container(
//                         width: 0,
//                         height: 0,
//                       )),
//       ),
//     );
//   }
// }
