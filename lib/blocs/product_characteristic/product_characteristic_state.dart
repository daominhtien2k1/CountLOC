import 'package:cosmetic_frontend/models/models.dart';

enum ProductCharacteristicStatus {initial, loading, success, failure }

class ProductCharacteristicState {
  ProductCharacteristicStatus productCharacteristicStatus;
  ProductCharacteristic? productCharacteristic;

  ProductCharacteristicState({required this.productCharacteristicStatus, this.productCharacteristic});

  ProductCharacteristicState.init(): productCharacteristicStatus = ProductCharacteristicStatus.initial, productCharacteristic = null;

  ProductCharacteristicState copyWith({ProductCharacteristicStatus? productCharacteristicStatus, ProductCharacteristic? productCharacteristic}) {
    return ProductCharacteristicState(
      productCharacteristicStatus: productCharacteristicStatus ?? this.productCharacteristicStatus,
      productCharacteristic: productCharacteristic ?? this.productCharacteristic
    );
  }
}