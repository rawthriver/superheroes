import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback action;

  const ActionButton({
    super.key,
    required this.text,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: SuperheroesColors.main,
        ),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 14,
            height: 1.7,
            fontWeight: FontWeight.w700,
            color: SuperheroesColors.text,
          ),
        ),
      ),
    );
  }
}
