import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ShowRatingWidget extends StatelessWidget {
  final double? rate;
  final double size;
  final bool isCenter;

  ShowRatingWidget(this.rate, {this.size = 26, this.isCenter = true});
  @override
  Widget build(BuildContext context) {
    return isCenter
        ? Center(
            child: RatingBar(
              initialRating: rate ?? 0.0,
              minRating: 1,
              ignoreGestures: true,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.zero,
              itemSize: size,
              ratingWidget: RatingWidget(
                  full: Icon(
                    Icons.star,
                    color: Colors.yellow.shade700,
                  ),
                  half: Icon(
                    Icons.star_half,
                    color: Colors.yellow.shade700,
                    textDirection: TextDirection.ltr,
                  ),
                  empty: Icon(
                    Icons.star,
                    color: Colors.teal.shade200,
                  )),
              unratedColor: Colors.teal.shade200,
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
          )
        : RatingBar(
            initialRating: rate ?? 0.0,
            minRating: 1,
            ignoreGestures: true,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.zero,
            itemSize: size,
            ratingWidget: RatingWidget(
                full: Icon(
                  Icons.star,
                  color: Colors.yellow.shade700,
                ),
                half: Icon(
                  Icons.star_half,
                  color: Colors.yellow.shade700,
                  textDirection: TextDirection.ltr,
                ),
                empty: Icon(
                  Icons.star,
                  color: Colors.teal.shade200,
                )),
            unratedColor: Colors.teal.shade200,
            onRatingUpdate: (rating) {
              print(rating);
            },
          );
  }
}
