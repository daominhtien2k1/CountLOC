import 'package:bloc/bloc.dart';
import 'package:cosmetic_frontend/blocs/product/product_event.dart';
import 'package:cosmetic_frontend/blocs/product/product_state.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  ProductBloc({required this.productRepository}): super(ProductState.initial()) {
    on<HomeAllTypeProductFetched>(_onHomeAllTypeProductFetched);
  }

  Future<void> _onHomeAllTypeProductFetched(HomeAllTypeProductFetched event, Emitter<ProductState> emit) async {
    try {
      emit(state.copyWith(productStatus: ProductStatus.loading));
      final List<Product>? popularProducts = await productRepository.fetchPopularProducts();
      final List<Product>? exclusiveProducts = await productRepository.fetchPopularProducts();
      final List<Product>? upcomingProducts = await productRepository.fetchPopularProducts();
      final List<Product>? newProducts = await productRepository.fetchPopularProducts();
      emit(state.copyWith(productStatus: ProductStatus.success, popularProducts: popularProducts, exclusiveProducts: exclusiveProducts, upcomingProducts: upcomingProducts, newProducts: newProducts));
    } catch (err) {
      emit(state.copyWith(productStatus: ProductStatus.failure));
    }
  }


}