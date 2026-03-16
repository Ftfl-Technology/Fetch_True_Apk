// lib/feature/user/bloc/additional_details_event.dart
import 'package:equatable/equatable.dart';

abstract class AdditionalDetailsEvent extends Equatable {
  const AdditionalDetailsEvent();

  @override
  List<Object?> get props => [];
}

class UpdateAdditionalDetailsEvent extends AdditionalDetailsEvent {
  final String userId;
  final Map<String, dynamic> data;

  const UpdateAdditionalDetailsEvent({required this.userId, required this.data});

  @override
  List<Object?> get props => [userId, data];
}
