import 'package:equatable/equatable.dart';

abstract class ProductCarouselEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductCarouselFetch extends ProductCarouselEvent {}