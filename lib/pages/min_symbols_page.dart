import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

class MinSymbolsPage extends StatelessWidget {
  const MinSymbolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 110, left: 16, right: 16),
        child: Text(
          'Enter at least 3 symbols',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: SuperheroesColors.text,
          ),
        ),
      ),
    );
  }
}
