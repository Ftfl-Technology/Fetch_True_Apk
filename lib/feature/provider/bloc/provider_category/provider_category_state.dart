import 'package:equatable/equatable.dart';

import '../../model/provider_category_model.dart';

abstract class ProviderCategoryState extends Equatable {
  const ProviderCategoryState();

  @override
  List<Object> get props => [];
}

class ProviderCategoryInitial extends ProviderCategoryState {}

class ProviderCategoryLoading extends ProviderCategoryState {}

class ProviderCategoryLoaded extends ProviderCategoryState {
  final List<ProviderCategoryModel> categories;

  const ProviderCategoryLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class ProviderCategoryError extends ProviderCategoryState {
  final String message;

  const ProviderCategoryError(this.message);

  @override
  List<Object> get props => [message];
}
