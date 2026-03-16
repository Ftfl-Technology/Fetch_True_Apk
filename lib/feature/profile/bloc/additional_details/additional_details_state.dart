// lib/feature/user/bloc/additional_details_state.dart
import 'package:equatable/equatable.dart';

abstract class AdditionalDetailsState extends Equatable {
  const AdditionalDetailsState();

  @override
  List<Object?> get props => [];
}

class AdditionalDetailsInitial extends AdditionalDetailsState {}

class AdditionalDetailsLoading extends AdditionalDetailsState {}

class AdditionalDetailsSuccess extends AdditionalDetailsState {}

class AdditionalDetailsFailure extends AdditionalDetailsState {
  final String error;
  const AdditionalDetailsFailure(this.error);

  @override
  List<Object?> get props => [error];
}
