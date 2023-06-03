import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:cosmetic_frontend/models/models.dart';

class ProductDetailImageCarouselSlider extends StatefulWidget {
  final List<Carousel> carouselList;
  ProductDetailImageCarouselSlider({required this.carouselList});

  @override
  _ProductDetailImageCarouselSliderState createState() => _ProductDetailImageCarouselSliderState();
}

class _ProductDetailImageCarouselSliderState extends State<ProductDetailImageCarouselSlider> {
  int _current = 0;
  late List<Widget> imageSlider;

  @override
  void initState() {
    imageSlider = widget.carouselList.map((crs) => Container(
      margin: EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: CachedNetworkImage(
          imageUrl: crs.url,
          errorWidget: (context, url, error) =>
              Icon(Icons.error),
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              Center(
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                ),
              ),
          fit: BoxFit.cover,
          width: 1000,
        ),
      ),
    )).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CarouselSlider(
              items: imageSlider,
              options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  aspectRatio: 16/9,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.carouselList.map((crs) {
              int index = widget.carouselList.indexOf(crs);
              return Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}