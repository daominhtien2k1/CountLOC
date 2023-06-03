import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

import 'product_carousel_event.dart';
import 'product_carousel_state.dart';

class ProductCarouselBloc extends Bloc<ProductCarouselEvent, ProductCarouselState> {
  final ProductRepository productRepository;
  ProductCarouselBloc({required this.productRepository}): super(ProductCarouselState.initial()) {
    
    on<ProductCarouselFetch>(_onProductCarouselFetched);
  }

  Future<void> _onProductCarouselFetched(ProductCarouselFetch event, Emitter<ProductCarouselState> emit) async {
    try {
      emit(state.copyWith(productCarouselStatus: ProductCarouselStatus.loading));
      final List<Carousel>? carousels = await productRepository.fetchProductCarousel();
      if (carousels != null) {
        emit(ProductCarouselState(productCarouselStatus: ProductCarouselStatus.success, carousels: carousels));
      }
    } catch(error) {
      emit(state.copyWith(productCarouselStatus: ProductCarouselStatus.failure));
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    // print('#COMMENT OBSERVER: $error');
  }

  @override
  void onTransition(Transition<ProductCarouselEvent, ProductCarouselState> transition) {
    super.onTransition(transition);
    // print('#COMMENT OBSERVER: $transition');
  }

  @override
  void onEvent(ProductCarouselEvent event) {
    super.onEvent(event);
    // print('#COMMENT OBSERVER: $event');
  }

  @override
  void onChange(Change<ProductCarouselState> change) {
    super.onChange(change);
  }
  
}