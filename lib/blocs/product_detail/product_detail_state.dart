import 'package:cosmetic_frontend/models/models.dart';

enum ProductDetailStatus {initial, loading, success, failure }

class ProductDetailState {
  ProductDetailStatus productDetailStatus;
  ProductDetail? productDetail;
  List<RelateProduct>? relateProducts;
  List<String>? characteristics;

  ProductDetailState({required this.productDetailStatus, this.productDetail, this.relateProducts, this.characteristics});

  ProductDetailState.init(): productDetailStatus = ProductDetailStatus.initial, productDetail = null, relateProducts = null, characteristics = null;

  ProductDetailState copyWith({ProductDetailStatus? productDetailStatus, ProductDetail? productDetail, List<RelateProduct>? relateProducts, List<String>? characteristics}) {
    return ProductDetailState(
      productDetailStatus: productDetailStatus ?? this.productDetailStatus,
      productDetail: productDetail ?? this.productDetail,
      relateProducts: relateProducts ?? this.relateProducts,
      characteristics: characteristics ?? this.characteristics
    );
  }

}