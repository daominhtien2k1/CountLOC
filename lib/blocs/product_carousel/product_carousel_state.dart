import 'package:equatable/equatable.dart';

import '../../models/models.dart';

enum ProductCarouselStatus {initial, loading, success, failure }

class ProductCarouselState {
  ProductCarouselStatus productCarouselStatus;
  List<Carousel>? carousels;
  ProductCarouselState({required this.productCarouselStatus, required this.carousels});

  ProductCarouselState.initial(): productCarouselStatus = ProductCarouselStatus.initial, carousels = List<Carousel>.empty(growable: true);

  ProductCarouselState copyWith({ProductCarouselStatus? productCarouselStatus, List<Carousel>? carousels}) {
    return ProductCarouselState(
        productCarouselStatus: productCarouselStatus ?? this.productCarouselStatus,
        carousels: carousels ?? this.carousels
    );
  }
}