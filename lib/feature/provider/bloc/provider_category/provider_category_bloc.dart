import 'package:flutter_bloc/flutter_bloc.dart';
import 'provider_category_event.dart';
import 'provider_category_state.dart';
import '../../repository/provider_category_repository.dart';

class ProviderCategoryBloc
    extends Bloc<ProviderCategoryEvent, ProviderCategoryState> {

  final ProviderCategoryRepository repository;

  ProviderCategoryBloc(this.repository) : super(ProviderCategoryInitial()) {

    on<FetchProviderCategories>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
      FetchProviderCategories event,
      Emitter<ProviderCategoryState> emit,
      ) async {
    emit(ProviderCategoryLoading());

    try {
      final categories =
      await repository.getProviderCategories(event.providerId);

      emit(ProviderCategoryLoaded(categories));
    } catch (e) {
      emit(ProviderCategoryError(e.toString()));
    }
  }
}
