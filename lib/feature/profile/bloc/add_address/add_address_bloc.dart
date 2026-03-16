import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/add_address_repository.dart';
import 'add_address_event.dart';
import 'add_address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository _repository;

  AddressBloc(this._repository) : super(AddressInitial()) {
    on<AddOrUpdateAddressEvent>((event, emit) async {
      emit(AddressLoading());
      try {
        final message = await _repository.addOrUpdateAddress(
          userId: event.userId,
          addressModel: event.addressModel,
        );
        emit(AddressSuccess(message));
      } catch (e) {
        emit(AddressFailure(e.toString()));
      }
    });
  }
}
