import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:breaking_bad_app/blocs/characters_cubit/characters_cubit.dart';
import 'package:breaking_bad_app/blocs/characters_cubit/characters_states.dart';
import 'package:breaking_bad_app/data/models/character_model.dart';
import 'package:breaking_bad_app/shared/constants/colors.dart';
import 'package:breaking_bad_app/shared/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharactersDetailsScreen extends StatelessWidget {
  final CharacterModel characterModel;
  const CharactersDetailsScreen({Key? key, required this.characterModel})
      : super(key: key);

  buildAppBarSliver() {
    return SliverAppBar(
      elevation: 0.0,
      stretch: true,
      pinned: true,
      expandedHeight: 600,
      backgroundColor: ColorUsed.grey,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          characterModel.nickname.toString(),
          style: const TextStyle(
            color: ColorUsed.white,
          ),
        ),
        background: Hero(
          tag: characterModel.charId!.toInt(),
          child: Image.network(
            characterModel.img,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget charcterInfo(String title, String value) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: title,
          style: const TextStyle(
            color: ColorUsed.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        TextSpan(
          text: value,
          style: const TextStyle(
            color: ColorUsed.white,
            fontSize: 16.0,
          ),
        ),
      ]),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildDivider(double endIndent) {
    return Divider(
      color: ColorUsed.yellow,
      height: 30.0,
      endIndent: endIndent,
      thickness: 2.0,
    );
  }

  Widget checkIfQuotesAreLoaded(CharactersStates state) {
    if (state is QuoteLoadedState) {
      return displayRandomQuoteOrEmptySpace(state);
    } else {
      return buildCircularProgressIndicator();
    }
  }

  Widget displayRandomQuoteOrEmptySpace(QuoteLoadedState state) {
    var quotes = (state).quotes;

    if (quotes.isNotEmpty) {
      int randomQuote = Random().nextInt(quotes.length - 1);
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 20.0,
            color: ColorUsed.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0, 0),
                blurRadius: 7,
                color: ColorUsed.yellow,
              ),
            ],
          ),
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              FlickerAnimatedText(quotes[randomQuote].quote),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context)
        .getQuotes(characterModel.name.toString());
    return Scaffold(
      backgroundColor: ColorUsed.grey,
      body: CustomScrollView(
        slivers: [
          buildAppBarSliver(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      charcterInfo(
                        'Job : ',
                        characterModel.occupation!.join('/'),
                      ),
                      buildDivider(315.0),
                      charcterInfo(
                        'Appeard In : ',
                        characterModel.category.toString(),
                      ),
                      buildDivider(250.0),
                      charcterInfo(
                        'Seasons : ',
                        characterModel.appearance!.join('/'),
                      ),
                      buildDivider(280.0),
                      charcterInfo(
                        'Status : ',
                        characterModel.status.toString(),
                      ),
                      buildDivider(300.0),
                      characterModel.betterCallSaulAppearance!.isEmpty
                          ? Container()
                          : charcterInfo(
                              'Better Call Sauls Seassons : ',
                              characterModel.betterCallSaulAppearance!
                                  .join('/'),
                            ),
                      characterModel.betterCallSaulAppearance!.isEmpty
                          ? Container()
                          : buildDivider(120.0),
                      charcterInfo(
                        'Actor/Actress Name : ',
                        characterModel.portrayed.toString(),
                      ),
                      buildDivider(180.0),
                      const SizedBox(
                        height: 20.0,
                      ),
                      BlocBuilder<CharactersCubit, CharactersStates>(
                          builder: (context, state) {
                        return checkIfQuotesAreLoaded(state);
                      }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
