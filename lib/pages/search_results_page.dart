import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 114),
            Text(
              'Search results',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: SuperheroesColors.text,
              ),
            ),
            SizedBox(height: 20),
            SuperheroCard(
              name: 'Batman',
              realName: 'Bruce Wayne',
              imageUrl: 'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
            ),
            SizedBox(height: 8),
            SuperheroCard(
              name: 'Venom',
              realName: 'Eddie Brock',
              imageUrl: 'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg',
            ),
          ],
        ),
      ),
    );
  }
}
