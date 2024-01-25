import 'package:flutter/material.dart';
import 'package:superheroes/pages/main_page.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/info_with_button.dart';

class NoFavoritesPage extends StatelessWidget {
  const NoFavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var main = context.findAncestorWidgetOfExactType<MainPageContent>();
    return InfoWithButton(
      title: 'No favorites yet',
      subtitle: 'Search and add',
      buttonText: 'Search',
      assetImage: SuperheroesImages.noFavorites,
      imageWidth: 108,
      imageHeight: 119,
      imageTopPadding: 9,
      action: () => main?.setFocus(),
    );
  }
}
