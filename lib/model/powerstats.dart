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

  double _getPercent(final String value) => (int.tryParse(value) ?? 0) / 100;

  double get intelligencePercent => _getPercent(intelligence);
  double get strengthPercent => _getPercent(strength);
  double get speedPercent => _getPercent(speed);
  double get durabilityPercent => _getPercent(durability);
  double get powerPercent => _getPercent(power);
  double get combatPercent => _getPercent(combat);

  bool isNotEmpty() {
    return ![intelligence, strength, speed, durability, power, combat].any((e) => e == 'null');
  }

  factory Powerstats.fromJson(final Map<String, dynamic> json) => _$PowerstatsFromJson(json);

  Map<String, dynamic> toJson() => _$PowerstatsToJson(this);
}
