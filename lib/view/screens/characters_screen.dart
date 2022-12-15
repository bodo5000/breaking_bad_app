import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/characters_cubit/characters_states.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:breaking_bad_app/blocs/characters_cubit/characters_cubit.dart';
import 'package:breaking_bad_app/data/models/character_model.dart';
import 'package:breaking_bad_app/shared/constants/colors.dart';
import 'package:breaking_bad_app/shared/widgets/circular_progress_indicator.dart';
import '../widgets/characters_screen_widgets.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  List<CharacterModel> allCharacters = [];
  List<CharacterModel> searchedForCharacters = [];
  bool isSearched = false;
  final serachTextController = TextEditingController();

  Widget buildBlocBuilder() {
    return BlocBuilder<CharactersCubit, CharactersStates>(
        builder: (context, state) {
      if (state is CharactersLoadedState) {
        allCharacters = (state).characters;
        return buildLoadedListWidget();
      } else {
        return buildCircularProgressIndicator();
      }
    });
  }

  Widget buildLoadedListWidget() {
    return SingleChildScrollView(
      child: Container(
        color: ColorUsed.grey,
        child: Column(
          children: [buildCharactersList()],
        ),
      ),
    );
  }

  Widget buildCharactersList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1.0,
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: serachTextController.text.isEmpty
          ? allCharacters.length
          : searchedForCharacters.length,
      itemBuilder: (context, index) {
        return CharacterItem(
          characterModel: serachTextController.text.isEmpty
              ? allCharacters[index]
              : searchedForCharacters[index],
        );
      },
    );
  }

  Widget buildSearchFiled() {
    return TextField(
      controller: serachTextController,
      cursorColor: ColorUsed.grey,
      decoration: const InputDecoration(
        hintText: 'find a Character...',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: ColorUsed.grey,
          fontSize: 16.0,
        ),
      ),
      style: const TextStyle(
        color: ColorUsed.grey,
        fontSize: 18.0,
      ),
      onChanged: (searchedCharacter) {
        //will take the char i tybe and use it and see the items that has that char
        addSearchedItemsToSearchedList(searchedCharacter);
      },
    );
  }

  void addSearchedItemsToSearchedList(String searchedCharacter) {
    searchedForCharacters =
        allCharacters //will search allindex that has the condition
            .where((character) =>
                //condition => searchedCharacter
                character.name!.toLowerCase().startsWith(searchedCharacter))
            .toList();

    setState(() {});
  }

  List<Widget> appBarAction() {
    if (isSearched) {
      //search = flase
      return [
        IconButton(
          onPressed: () {
            clearSearch();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.clear,
            color: ColorUsed.grey,
          ),
        ),
      ];
    } else {
      //search = true

      return [
        IconButton(
          onPressed: startSearch,
          icon: const Icon(
            Icons.search,
            color: ColorUsed.grey,
          ),
        ),
      ];
    }
  }

  void startSearch() {
    //make seudo route
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(
      onRemove: stopSearching,
    ));
    setState(() {
      isSearched = true;
    });
  }

  void stopSearching() {
    clearSearch();

    setState(() {
      isSearched = false;
    });
  }

  void clearSearch() {
    setState(() {
      serachTextController.clear();
    });
  }

  Widget defualtAppBarTitle() {
    return const Text(
      'Characters',
      style: TextStyle(
        color: ColorUsed.grey,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    //here we make cubit not lazy
    BlocProvider.of<CharactersCubit>(context).getCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUsed.yellow,
        leading: isSearched
            ? const BackButton(
                color: ColorUsed.grey,
              )
            : null,
        title: isSearched ? buildSearchFiled() : defualtAppBarTitle(),
        actions: appBarAction(),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (BuildContext context,
            ConnectivityResult connectivity, Widget child) {
          final bool connected = connectivity != ConnectivityResult.none;

          if (connected) {
            return buildBlocBuilder();
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'There iS NO Connection',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: ColorUsed.grey,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Image(
                    image: AssetImage('assets/images/nonet.png'),
                  ),
                ],
              ),
            );
          }
        },
        child: buildCircularProgressIndicator(),
      ),
    );
  }
}
