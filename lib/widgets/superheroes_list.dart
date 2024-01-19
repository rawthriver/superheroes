import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class SuperheroesList extends StatelessWidget {
  final String title;
  final Stream<List<SuperheroInfo>> stream;

  const SuperheroesList({
    super.key,
    required this.title,
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox();
        }
        final list = snapshot.data!;
        return ListView.separated(
          itemBuilder: (context, index) {
            if (index == 0) {
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
            } else {
              final item = list[index - 1];
              return SuperheroCard(
                name: item.name,
                realName: item.realName,
                imageUrl: item.imageUrl,
                action: () =>
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuperheroPage(name: item.name))),
              );
            }
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemCount: list.length + 1,
        );
      },
    );
  }
}
