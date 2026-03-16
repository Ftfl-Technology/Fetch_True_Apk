import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {

    on<GetUserById>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await userRepository.getUserById(event.userId);
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<UpdateUser>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await userRepository.updateUser(event.userId, event.updatedData);
        emit(UserUpdated(user));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<UpdateProfilePhoto>((event, emit) async {
      emit(UserLoading());
      try {
        await userRepository.updateProfilePhoto(event.userId, event.filePath);

        final updatedUser = await userRepository.getUserById(event.userId);

        emit(UserLoaded(updatedUser));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<ResetUser>((event, emit) {
      emit(UserInitial());
    });

    on<DeleteUser>((event, emit) async {
      emit(UserLoading());
      try {
        await userRepository.deleteUser(event.userId);
        emit(UserDeleted());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

  }
}
