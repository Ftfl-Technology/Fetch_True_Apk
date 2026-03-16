import 'package:equatable/equatable.dart';
import '../../model/it_popular_service_model.dart';


abstract class ItPopularServiceState extends Equatable {
  const ItPopularServiceState();

  @override
  List<Object> get props => [];
}

class ItPopularServiceInitial
    extends ItPopularServiceState {}

class ItPopularServiceLoading
    extends ItPopularServiceState {}

class ItPopularServiceLoaded
    extends ItPopularServiceState {
  final ItPopularServiceModel data;

  const ItPopularServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class ItPopularServiceError
    extends ItPopularServiceState {
  final String message;

  const ItPopularServiceError(this.message);

  @override
  List<Object> get props => [message];
}
