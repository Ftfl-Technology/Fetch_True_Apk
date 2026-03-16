import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/category_cover_model.dart';
import '../../repository/category_cover_repository.dart';

part 'category_cover_event.dart';
part 'category_cover_state.dart';

class CategoryCoverBloc extends Bloc<CategoryCoverEvent, CategoryCoverState> {
  final CategoryCoverRepository _repository = CategoryCoverRepository();

  CategoryCoverBloc() : super(CategoryCoverInitial()) {
    on<FetchCategoryCover>(_onFetchCategoryCover);
  }

  Future<void> _onFetchCategoryCover(
      FetchCategoryCover event,
      Emitter<CategoryCoverState> emit,
      ) async {
    emit(CategoryCoverLoading());
    try {
      final data = await _repository.getCategoryBanner(moduleId: event.moduleId);
      emit(CategoryCoverSuccess(data: data));
    } catch (e) {
      emit(CategoryCoverFailure(error: e.toString()));
    }
  }
}