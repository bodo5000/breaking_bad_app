import 'package:breaking_bad_app/blocs/characters_cubit/characters_states.dart';
import 'package:breaking_bad_app/data/repository/characters_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharactersCubit extends Cubit<CharactersStates> {
  final CharactersRepository charactersRepository;

  CharactersCubit(this.charactersRepository) : super(CharactersInitState());

  void getCharacters() {
    charactersRepository.fetchCharactersData().then((characters) {
      emit(CharactersLoadedState(characters));
      //the date that saved in character list state will be pass to the character cubit list
    });
  }

  void getQuotes(String authorName) {
    charactersRepository.fetchQuotesData(authorName).then((qoute) {
      emit(QuoteLoadedState(qoute));
    });
  }
}
