import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';

class NoFavoritesPage extends StatelessWidget {
  const NoFavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                decoration: const BoxDecoration(color: SuperheroesColors.main, shape: BoxShape.circle),
                child: const SizedBox(
                  width: 108,
                  height: 108,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9),
                child: Image.asset(
                  SuperheroesImages.noFavorites,
                  width: 108,
                  height: 119,
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: SuperheroesColors.text,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Search and add'.toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: SuperheroesColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
