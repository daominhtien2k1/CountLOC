import 'package:equatable/equatable.dart';

abstract class ProductCharacteristicEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductCharacteristicFetched extends ProductCharacteristicEvent {
  final String productId;

  ProductCharacteristicFetched({required this.productId});
}