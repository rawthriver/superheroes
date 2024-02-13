import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

class AlignmentInfo {
  final String name;
  final Color color;

  const AlignmentInfo._({
    required this.name,
    required this.color,
  });

  static const bad = AlignmentInfo._(name: 'bad', color: SuperheroesColors.red);
  static const good = AlignmentInfo._(name: 'good', color: SuperheroesColors.green);
  static const neutral = AlignmentInfo._(name: 'neutral', color: SuperheroesColors.grey);

  static AlignmentInfo? fromString(final String a) {
    return switch (a) {
      'bad' => bad,
      'good' => good,
      'neutral' => neutral,
      _ => null,
    };
  }
}
