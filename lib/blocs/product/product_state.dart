import 'package:equatable/equatable.dart';

import '../../models/models.dart';

enum ProductStatus {initial, loading, success, failure }

class ProductState {
  ProductStatus productStatus;
  List<Product>? popularProducts;
  List<Product>? exclusiveProducts;
  List<Product>? upcomingProducts;
  List<Product>? newProducts;

  ProductState({
    required this.productStatus,
    required this.popularProducts,
    required this.exclusiveProducts,
    required this.upcomingProducts,
    required this.newProducts
  });

  ProductState.initial(): productStatus = ProductStatus.initial, popularProducts = null, exclusiveProducts = null, upcomingProducts = null, newProducts = null;

  ProductState copyWith({
    ProductStatus? productStatus,
    List<Product>? popularProducts,
    List<Product>? exclusiveProducts,
    List<Product>? upcomingProducts,
    List<Product>? newProducts
  }) {
    return ProductState(
      productStatus: productStatus ?? this.productStatus,
      popularProducts: popularProducts ?? this.popularProducts,
      exclusiveProducts: exclusiveProducts ?? this.exclusiveProducts,
      upcomingProducts: upcomingProducts ?? this.upcomingProducts,
      newProducts: newProducts ?? this.newProducts
    );
  }
}