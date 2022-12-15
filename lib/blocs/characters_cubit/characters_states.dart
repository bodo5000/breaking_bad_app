import 'package:breaking_bad_app/data/models/character_model.dart';
import 'package:breaking_bad_app/data/models/quote_model.dart';

abstract class CharactersStates {}

class CharactersInitState extends CharactersStates {}

class CharactersLoadedState extends CharactersStates {
  //if Characters is loaded state we will return list of this characterModel
  List<CharacterModel> characters = [];

  CharactersLoadedState(this.characters);
}

class QuoteLoadedState extends CharactersStates {
  //if Characters is loaded state we will return list of this qoutemodel
  List<QuoteModel> quotes = [];

  QuoteLoadedState(this.quotes);
}
