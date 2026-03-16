// lib/feature/user/bloc/additional_details_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/additinal_details_repository.dart';
import 'additional_details_event.dart';
import 'additional_details_state.dart';

class AdditionalDetailsBloc
    extends Bloc<AdditionalDetailsEvent, AdditionalDetailsState> {
  final UserAdditionalDetailsService service;

  AdditionalDetailsBloc({required this.service})
      : super(AdditionalDetailsInitial()) {
    on<UpdateAdditionalDetailsEvent>(_onUpdateAdditionalDetails);
  }

  Future<void> _onUpdateAdditionalDetails(
      UpdateAdditionalDetailsEvent event,
      Emitter<AdditionalDetailsState> emit,
      ) async {
    emit(AdditionalDetailsLoading());
    try {
      await service.updateAdditionalDetails(
        userId: event.userId,
        data: event.data,
      );
      emit(AdditionalDetailsSuccess());
    } catch (e) {
      emit(AdditionalDetailsFailure(e.toString()));
    }
  }
}
