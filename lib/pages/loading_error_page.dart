// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/info_with_button.dart';

class LoadingErrorPage extends StatelessWidget {
  const LoadingErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context);
    return StreamBuilder(
      stream: bloc.errorSubject,
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
        action: bloc.retry,
      ),
    );
  }
}
