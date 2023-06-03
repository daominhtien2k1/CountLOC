import 'package:flutter/material.dart';

class StarList extends StatelessWidget {
  final double rating;
  final Color? color;
  final double? size;

  const StarList({required this.rating, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    final int wholeStars = rating.floor();
    final bool hasHalfStar = rating - wholeStars >= 0.25 && rating - wholeStars < 0.75;
    final bool hasRoundUpStar = rating - wholeStars >= 0.75;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < wholeStars) {
          return Icon(Icons.star, color: color ?? Colors.grey, size: size ?? 16);
        } else if (index == wholeStars && hasHalfStar) {
          return Icon(Icons.star_half, color: color ?? Colors.grey, size: size ?? 16);
        } else if (index == wholeStars && hasRoundUpStar) {
          return Icon(Icons.star, color: color ?? Colors.grey, size: size ?? 16);
        } else {
          return Icon(Icons.star_border, color: color ?? Colors.grey, size: size ?? 16);
        }
      }),
    );
  }
}