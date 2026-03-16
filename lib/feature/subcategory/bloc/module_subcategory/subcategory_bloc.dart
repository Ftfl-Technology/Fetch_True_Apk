// subcategory_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/subcategory_repository.dart';
import 'subcategory_event.dart';
import 'subcategory_state.dart';

class SubcategoryBloc extends Bloc<SubcategoryEvent, SubcategoryState> {
  final SubcategoryRepository repository;

  SubcategoryBloc(this.repository) : super(SubcategoryInitial()) {
    on<FetchSubcategories>((event, emit) async {
      emit(SubcategoryLoading());
      try {
        final subcategories = await repository.getSubcategories();
        emit(SubcategoryLoaded(subcategories));
      } catch (e) {
        emit(SubcategoryError(e.toString()));
      }
    });
  }
}
