import 'package:breaking_bad_app/data/models/character_model.dart';
import 'package:breaking_bad_app/shared/constants/colors.dart';
import 'package:breaking_bad_app/shared/constants/routes_names.dart';
import 'package:flutter/material.dart';

class CharacterItem extends StatelessWidget {
  final CharacterModel characterModel;

  const CharacterItem({Key? key, required this.characterModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ColorUsed.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            charactersDetailsScreen,
            arguments: characterModel,
          );
        },
        child: Hero(
          tag: characterModel.charId!.toInt(),
          child: GridTile(
            footer: Container(
              alignment: Alignment.bottomCenter,
              color: Colors.black54,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Text(
                '${characterModel.name}',
                style: const TextStyle(
                  height: 1.3,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: ColorUsed.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: ColorUsed.grey,
              child: characterModel.img.isNotEmpty
                  ? FadeInImage.assetNetwork(
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: 'assets/images/loading2.gif',
                      fit: BoxFit.cover,
                      image: characterModel.img,
                    )
                  : Image.asset('assets/images/place.png'),
            ),
          ),
        ),
      ),
    );
  }
}
