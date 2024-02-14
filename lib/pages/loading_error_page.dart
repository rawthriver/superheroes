// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/info_with_button.dart';

class LoadingErrorPage extends StatelessWidget {
  final Stream<Exception> stream;
  final VoidCallback retry;

  const LoadingErrorPage({
    super.key,
    required this.stream,
    required this.retry,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) => InfoWithButton(
        title: snapshot.hasData && snapshot.data is ApiException
            ? (snapshot.data as ApiException).message
            : 'Error happened',
        subtitle: 'Please, try again',
        buttonText: 'Retry',
        assetImage: SuperheroesImages.loadingError,
        imageWidth: 126,
        imageHeight: 106,
        imageTopPadding: 22,
        action: retry,
      ),
    );
  }
}
