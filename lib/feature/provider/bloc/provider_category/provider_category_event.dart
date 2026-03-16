import 'package:equatable/equatable.dart';

abstract class ProviderCategoryEvent extends Equatable {
  const ProviderCategoryEvent();

  @override
  List<Object> get props => [];
}

class FetchProviderCategories extends ProviderCategoryEvent {
  final String providerId;

  const FetchProviderCategories(this.providerId);

  @override
  List<Object> get props => [providerId];
}
