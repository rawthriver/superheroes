import 'package:json_annotation/json_annotation.dart';

part 'powerstats.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class Powerstats {
  final String intelligence;
  final String strength;
  final String speed;
  final String durability;
  final String power;
  final String combat;

  const Powerstats(
    this.intelligence,
    this.strength,
    this.speed,
    this.durability,
    this.power,
    this.combat,
  );

  factory Powerstats.fromJson(final Map<String, dynamic> json) => _$PowerStatsFromJson(json);

  Map<String, dynamic> toJson() => _$PowerStatsToJson(this);
}
