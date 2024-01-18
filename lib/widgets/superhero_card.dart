import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

class SuperheroCard extends StatelessWidget {
  final String name;
  final String realName;
  final String imageUrl;
  final VoidCallback action;

  const SuperheroCard({
    super.key,
    required this.name,
    required this.realName,
    required this.imageUrl,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: SuperheroesColors.card,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(children: [
          Image.network(
            imageUrl,
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
                  name.toUpperCase(),
                  style: const TextStyle(
                    color: SuperheroesColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  realName,
                  style: const TextStyle(
                    color: SuperheroesColors.text,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          //const SizedBox(width: 28),
        ]),
      ),
    );
  }
}
