import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/favorites_page.dart';
import 'package:superheroes/pages/loading_error_page.dart';
import 'package:superheroes/pages/min_symbols_page.dart';
import 'package:superheroes/pages/no_favorites_page.dart';
import 'package:superheroes/pages/nothing_found_page.dart';
import 'package:superheroes/pages/search_results_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/search_widget.dart';
import 'package:superheroes/widgets/superheroes_list.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainBloc bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: const Scaffold(
        backgroundColor: SuperheroesColors.background,
        body: SafeArea(
          child: MainPageContent(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MainPageContent extends StatelessWidget {
  const MainPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return Stack(
      children: [
        const MainPageStateWidget(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ActionButton(
              text: 'Next state',
              action: bloc.nextState,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 12),
          child: SearchWidget(),
        ),
      ],
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  const MainPageStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder<MainPageState>(
      stream: bloc.observeMainPageState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox();
        }
        MainPageState state = snapshot.data!;
        switch (state) {
          case MainPageState.loading:
            return const LoadingIndicator();
          case MainPageState.minSymbols:
            return const MinSymbolsPage();
          case MainPageState.noFavorites:
            return const NoFavoritesPage();
          case MainPageState.favorites:
            return SuperheroesList(
              title: 'Your favorites',
              stream: bloc.observeFavorites(),
            );
          case MainPageState.searchResults:
            // return const SearchResultsPage();
            return SuperheroesList(
              title: 'Search results',
              stream: bloc.observeSearched(),
            );
          case MainPageState.nothingFound:
            return const NothingFoundPage();
          case MainPageState.loadingError:
            return const LoadingErrorPage();
          default:
            return Center(
              child: Text(
                state.toString(),
                style: const TextStyle(
                  color: SuperheroesColors.text,
                ),
              ),
            );
        }
      },
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 110),
        child: CircularProgressIndicator(color: SuperheroesColors.main),
      ),
    );
  }
}
