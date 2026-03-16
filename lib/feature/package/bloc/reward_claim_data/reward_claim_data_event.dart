import 'package:equatable/equatable.dart';


abstract class ClaimNowDataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchClaimNowDataEvent extends ClaimNowDataEvent {}
