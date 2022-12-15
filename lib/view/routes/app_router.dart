import 'package:breaking_bad_app/blocs/characters_cubit/characters_cubit.dart';
import 'package:breaking_bad_app/data/models/character_model.dart';
import 'package:breaking_bad_app/data/repository/characters_repository.dart';
import 'package:breaking_bad_app/data/web_services/characters_web_services.dart';
import 'package:breaking_bad_app/shared/constants/routes_names.dart';
import 'package:breaking_bad_app/view/screens/characters_details_screen.dart';
import 'package:breaking_bad_app/view/screens/characters_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;

  AppRouter() {
    charactersRepository = CharactersRepository(CharacterwsWebServices());
    charactersCubit = CharactersCubit(charactersRepository);
  }

  Route? genterateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => charactersCubit,
              ),
            ],
            child: const CharactersScreen(),
          ),
        );

      case charactersDetailsScreen:
        //here we will pass data from charactersScreen to CharactersDetailsScreen
        final characterModel = settings.arguments as CharacterModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => CharactersCubit(charactersRepository),
            child: CharactersDetailsScreen(
              characterModel: characterModel,
            ),
          ),
        );
    }
    return null;
  }
}
