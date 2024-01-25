import 'package:flutter/material.dart';
import 'package:superheroes/pages/main_page.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/info_with_button.dart';

class NothingFoundPage extends StatelessWidget {
  const NothingFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    var main = context.findAncestorWidgetOfExactType<MainPageContent>();
    return InfoWithButton(
      title: 'Nothing found',
      subtitle: 'Search for something else',
      buttonText: 'Search',
      assetImage: SuperheroesImages.nohtingFound,
      imageWidth: 84,
      imageHeight: 112,
      imageTopPadding: 16,
      action: () => main?.setFocus(),
    );
  }
}
