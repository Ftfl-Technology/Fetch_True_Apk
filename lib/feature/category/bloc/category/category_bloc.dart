import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fetchtrue/feature/category/model/category_model.dart';
import 'package:fetchtrue/feature/category/repository/category_repository.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc(this.categoryRepository) : super(CategoryInitial()) {
    on<GetCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final List<CategoryModel> categories =
        await categoryRepository.getCategory();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}
