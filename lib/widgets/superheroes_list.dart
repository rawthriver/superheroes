import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class SuperheroesList extends StatelessWidget {
  final String title;
  final Stream<List<SuperheroInfo>> stream;
  final bool swipeEnabled;

  const SuperheroesList({
    super.key,
    required this.title,
    required this.stream,
    this.swipeEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }
        final list = snapshot.data!;
        return ListView.separated(
          itemBuilder: (_, index) {
            if (index == 0) {
              return ListTitle(title: title);
            } else {
              return ListTile(hero: list[index - 1], swipeEnabled: swipeEnabled);
            }
          },
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemCount: list.length + 1,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        );
      },
    );
  }
}

class ListTile extends StatelessWidget {
  final SuperheroInfo hero;
  final bool swipeEnabled;

  const ListTile({
    super.key,
    required this.hero,
    this.swipeEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    Widget card = SuperheroCard(
      info: hero,
      action: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuperheroPage(id: hero.id))),
      swipeEnabled: swipeEnabled,
    );
    if (swipeEnabled) {
      card = ClipRRect(
        // unclipped corners fix
        borderRadius: BorderRadius.circular(8),
        child: Dismissible(
          key: ValueKey(hero.id),
          background: const DismissWidget(isLeft: true),
          secondaryBackground: const DismissWidget(isLeft: false),
          onDismissed: (_) => bloc.removeSuperhero(hero.id),
          child: card,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: card,
    );
  }
}

class DismissWidget extends StatelessWidget {
  final bool isLeft;

  const DismissWidget({
    super.key,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.circular(8),
        color: SuperheroesColors.red,
      ),
      child: Text(
        'Remove\nfrom\nfavorites'.toUpperCase(),
        textAlign: isLeft ? TextAlign.left : TextAlign.right,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: SuperheroesColors.text,
        ),
      ),
    );
  }
}

class ListTitle extends StatelessWidget {
  const ListTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 90, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: SuperheroesColors.text,
        ),
      ),
    );
  }
}
