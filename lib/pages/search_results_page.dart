import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/superheroes_list.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context);
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16), //better than 3 paddings
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 90),
            const Text(
              'Search results',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: SuperheroesColors.text,
              ),
            ),
            const SizedBox(height: 20),
            SuperheroesList(
              title: 'Search results',
              stream: bloc.observeSearched(),
            ),
          ],
        ),
      ),
    );
  }
}
