import 'package:equatable/equatable.dart';
import 'package:cosmetic_frontend/models/models.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeAllTypeProductFetched extends ProductEvent {

}