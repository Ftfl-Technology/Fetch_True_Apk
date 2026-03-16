import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_snackbar.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../../profile/bloc/user/user_state.dart';
import '../bloc/provider/favorite_provider_bloc.dart';
import '../bloc/provider/favorite_provider_event.dart';
import '../bloc/provider/favorite_provider_state.dart';
import '../repository/favorite_provider_repository.dart';

class FavoriteProviderButtonWidget extends StatelessWidget {
  final String providerId;
  const FavoriteProviderButtonWidget({super.key, required this.providerId});

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const SizedBox.shrink();
        } else if (state is UserLoaded) {
          final user = state.user;
          final isFavorite = user.favoriteProviders.contains(providerId);

          return BlocProvider(
            create: (_) => FavoriteProviderBloc(FavoriteProviderRepository()),
            child: BlocConsumer<FavoriteProviderBloc, FavoriteProviderState>(
              listenWhen: (previous, current) =>
              current is FavoriteProviderSuccess || current is FavoriteProviderFailure,
              listener: (context, favState) {
                if (favState is FavoriteProviderSuccess && favState.providerId == providerId) {
                  context.read<UserBloc>().add(GetUserById(userSession.userId!));
                }
              },
              builder: (context, favState) {
                if (favState is FavoriteProviderLoading && favState.providerId == providerId) {
                  return const SizedBox(
                    width: 20,
                    height: 20,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 3, color: Colors.red),
                    ),
                  );
                }

                return InkWell(
                  child: Icon(
                    isFavorite ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.red,
                  ),
                  onTap: () {
                    if (isFavorite) {
                      context.read<FavoriteProviderBloc>().add(RemoveFavoriteProviderEvent(user.id, providerId));
                    } else {
                      context.read<FavoriteProviderBloc>().add(AddFavoriteProviderEvent(user.id, providerId));
                    }
                  },
                );
              },
            ),
          );
        } else if (state is UserError) {
          return InkWell(
              onTap: () {
                showCustomToast('Please first you sign in');
              },
              child: Icon(Icons.favorite_border, color: Colors.red,));
        }

        return InkWell(
            onTap: () {
              showCustomToast('Please first you sign in');
            },
            child: Icon(Icons.favorite_border, color: Colors.red,));
      },
    );
  }
}
