import 'package:json_annotation/json_annotation.dart';

part 'powerstats.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class PowerStats {
  final String intelligence;
  final String strength;
  final String speed;
  final String durability;
  final String power;
  final String combat;

  const PowerStats(
    this.intelligence,
    this.strength,
    this.speed,
    this.durability,
    this.power,
    this.combat,
  );

  factory PowerStats.fromJson(final Map<String, dynamic> json) => _$PowerStatsFromJson(json);

  Map<String, dynamic> toJson() => _$PowerStatsToJson(this);
}
