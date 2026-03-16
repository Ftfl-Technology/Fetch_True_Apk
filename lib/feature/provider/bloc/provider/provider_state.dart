import 'package:equatable/equatable.dart';

import '../../model/provider_model.dart';

abstract class ProviderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProviderInitial extends ProviderState {}

class ProviderLoading extends ProviderState {}

// class ProvidersLoaded extends ProviderState {
//   final List<ProviderModel> providers;
//   ProvidersLoaded(this.providers);
//
//   @override
//   List<Object?> get props => [providers];
// }

class ProvidersLoaded extends ProviderState {
  final List<ProviderModel> providers; // Original list
  final String selectedFilter;

  ProvidersLoaded({
    required this.providers,
    this.selectedFilter = 'All',
  });

  List<ProviderModel> get filteredProviders {
    List<ProviderModel> list = List.from(providers);

    if (selectedFilter == 'Newly Joined') {
      list.sort((a, b) {
        final bDate = b.createdAt ?? DateTime(1970);
        final aDate = a.createdAt ?? DateTime(1970);
        return bDate.compareTo(aDate);
      });
    } else if (selectedFilter == 'Popular') {
      list.sort((a, b) => b.totalReviews.compareTo(a.totalReviews));
    } else if (selectedFilter == 'Top Rated') {
      list.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    }
    return list;
  }

  ProvidersLoaded copyWith({String? selectedFilter}) {
    return ProvidersLoaded(
      providers: providers,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [providers, selectedFilter];
}


class ProviderLoaded extends ProviderState {
  final ProviderModel provider;
  ProviderLoaded(this.provider);

  @override
  List<Object?> get props => [provider];
}

class ProviderError extends ProviderState {
  final String message;
  ProviderError(this.message);

  @override
  List<Object?> get props => [message];
}