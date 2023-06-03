import 'package:cosmetic_frontend/blocs/product_characteristic/product_characteristic_event.dart';
import 'package:cosmetic_frontend/blocs/product_characteristic/product_characteristic_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/repositories.dart';

class ProductCharacteristicBloc extends Bloc<ProductCharacteristicEvent, ProductCharacteristicState> {
  late final ReviewRepository reviewRepository;

  ProductCharacteristicBloc({required this.reviewRepository}): super(ProductCharacteristicState.init()) {
    on<ProductCharacteristicFetched>(_onProductCharacteristicFetched);
  }

  Future<void> _onProductCharacteristicFetched(ProductCharacteristicFetched event, Emitter<ProductCharacteristicState> emitter) async {
    try {
      final productId = event.productId;
      emit(state.copyWith(productCharacteristicStatus: ProductCharacteristicStatus.loading));
      final productCharacteristic = await reviewRepository.fetchProductCharacteristicStatistics(productId: productId);
      emit(state.copyWith(productCharacteristicStatus: ProductCharacteristicStatus.success, productCharacteristic: productCharacteristic));
    } catch (err) {
      emit(state.copyWith(productCharacteristicStatus: ProductCharacteristicStatus.failure));
    }
  }

}