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
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: SuperheroesColors.main,
      ),
      child: GestureDetector(
        onTap: action,
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
