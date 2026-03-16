part of 'category_cover_bloc.dart';

abstract class CategoryCoverState {}

class CategoryCoverInitial extends CategoryCoverState {}

class CategoryCoverLoading extends CategoryCoverState {}

class CategoryCoverSuccess extends CategoryCoverState {
  final CategoryCoverModel data;
  CategoryCoverSuccess({required this.data});
}

class CategoryCoverFailure extends CategoryCoverState {
  final String error;
  CategoryCoverFailure({required this.error});
}