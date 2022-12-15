import 'package:breaking_bad_app/data/models/character_model.dart';
import 'package:breaking_bad_app/data/models/quote_model.dart';
import 'package:breaking_bad_app/data/web_services/characters_web_services.dart';

class CharactersRepository {
  CharacterwsWebServices characterwsWebServices;

  CharactersRepository(this.characterwsWebServices);

  Future<List<CharacterModel>> fetchCharactersData() async {
    try {
      final characters = await characterwsWebServices.requestCharacters();
      return characters
          .map((character) => CharacterModel.fromJson(character))
          .toList();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<QuoteModel>> fetchQuotesData(String authorName) async {
    try {
      final quotes = await characterwsWebServices.requestQuoets(authorName);
      return quotes
          .map((charQuotes) => QuoteModel.fromJson(charQuotes))
          .toList();
    } catch (error) {
      throw Exception(error);
    }
  }
}
