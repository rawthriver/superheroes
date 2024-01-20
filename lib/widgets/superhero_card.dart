import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

class SuperheroCard extends StatelessWidget {
  final SuperheroInfo info;
  final VoidCallback action;

  const SuperheroCard({
    super.key,
    required this.info,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: SuperheroesColors.card,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(children: [
          Image.network(
            info.imageUrl,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.name.toUpperCase(),
                  style: const TextStyle(
                    color: SuperheroesColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  info.realName,
                  style: const TextStyle(
                    color: SuperheroesColors.text,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
