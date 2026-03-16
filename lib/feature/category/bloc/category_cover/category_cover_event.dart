part of 'category_cover_bloc.dart';

abstract class CategoryCoverEvent {}

class FetchCategoryCover extends CategoryCoverEvent {
  final String moduleId;
  FetchCategoryCover({required this.moduleId});
}