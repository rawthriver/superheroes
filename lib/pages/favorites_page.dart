import 'package:flutter/material.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    VoidCallback openSuperHeroPage(name) {
      return () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuperheroPage(name: name)));
    }

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 114),
            const Text(
              'Your favorites',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: SuperheroesColors.text,
              ),
            ),
            const SizedBox(height: 20),
            SuperheroCard(
              name: 'Batman',
              realName: 'Bruce Wayne',
              imageUrl: 'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
              action: openSuperHeroPage('Batman'),
            ),
            const SizedBox(height: 8),
            SuperheroCard(
              name: 'Ironman',
              realName: 'Tony Stark',
              imageUrl: 'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg',
              action: openSuperHeroPage('Ironman'),
            ),
          ],
        ),
      ),
    );
  }
}