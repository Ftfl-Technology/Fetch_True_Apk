import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/share_one_commission_repository.dart';
import 'share_one_commission_event.dart';
import 'share_one_commission_state.dart';

class ShareOneCommissionBloc
    extends Bloc<ShareOneCommissionEvent, ShareOneCommissionState> {
  final ShareOneCommissionRepository repository;

  ShareOneCommissionBloc(this.repository)
      : super(ShareOneCommissionInitial()) {
    on<FetchShareOneCommission>((event, emit) async {
      emit(ShareOneCommissionLoading());
      try {
        final data =
        await repository.fetchShareOneCommission(event.id);
        emit(ShareOneCommissionLoaded(data));
      } catch (e) {
        emit(ShareOneCommissionError(e.toString()));
      }
    });
  }
}
