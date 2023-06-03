import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Friend extends StatelessWidget {
  final String friendName;
  final String imageUrl;

  const Friend({Key? key, required this.friendName, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black12,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.1,
            blurRadius: 0.1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image(
                  image: CachedNetworkImageProvider(imageUrl),
                  fit: BoxFit.fitWidth
                ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(friendName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }
}
