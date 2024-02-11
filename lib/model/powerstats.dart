import 'package:json_annotation/json_annotation.dart';

part 'powerstats.g.dart';

@JsonSerializable()
class Powerstats {
  final String intelligence;
  final String strength;
  final String speed;
  final String durability;
  final String power;
  final String combat;

  Powerstats({
    required this.intelligence,
    required this.strength,
    required this.speed,
    required this.durability,
    required this.power,
    required this.combat,
  });

  double _toPercent(final String value) => (int.tryParse(value) ?? 0) / 100;

  double get intelligencePercent => _toPercent(intelligence);
  double get strengthPercent => _toPercent(strength);
  double get speedPercent => _toPercent(speed);
  double get durabilityPercent => _toPercent(durability);
  double get powerPercent => _toPercent(power);
  double get combatPercent => _toPercent(combat);

  bool isNotEmpty() {
    return ![intelligence, strength, speed, durability, power, combat].any((e) => e == 'null');
  }

  factory Powerstats.fromJson(final Map<String, dynamic> json) => _$PowerstatsFromJson(json);

  Map<String, dynamic> toJson() => _$PowerstatsToJson(this);
}
