import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/info_with_button.dart';

class LoadingErrorPage extends StatelessWidget {
  const LoadingErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoWithButton(
      title: 'Error happened',
      subtitle: 'Please, try again',
      buttonText: 'Retry',
      assetImage: SuperheroesImages.loadingError,
      imageWidth: 126,
      imageHeight: 106,
      imageTopPadding: 22,
    );
  }
}
