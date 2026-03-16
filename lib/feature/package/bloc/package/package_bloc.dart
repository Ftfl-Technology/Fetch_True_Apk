
import 'package:fetchtrue/feature/package/bloc/package/package_event.dart';
import 'package:fetchtrue/feature/package/bloc/package/package_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/package_repository.dart';

class PackageBloc extends Bloc<PackageEvent, PackageState> {
  final PackageRepository repository;
  PackageBloc(this.repository) : super(PackageInitial()) {
    on<FetchPackages>((event, emit) async {
      emit(PackageLoading());
      try {
        final packages = await repository.getPackages(); // returns List<PackageModel>
        emit(PackageLoaded(packages));
      } catch (e) {
        emit(PackageError(e.toString()));
      }
    });
  }
}
