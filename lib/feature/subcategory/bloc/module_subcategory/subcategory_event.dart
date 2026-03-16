// subcategory_event.dart
import 'package:equatable/equatable.dart';

abstract class SubcategoryEvent extends Equatable {
  const SubcategoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchSubcategories extends SubcategoryEvent {}
