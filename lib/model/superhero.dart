import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/server_image.dart';
import 'package:json_annotation/json_annotation.dart';

part 'superhero.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class Superhero {
  final String id;
  final String name;
  final Biography biography;
  final ServerImage image;
  final Powerstats powerstats;

  const Superhero(
    this.id,
    this.name,
    this.biography,
    this.image,
    this.powerstats,
  );

  factory Superhero.fromJson(final Map<String, dynamic> json) => _$SuperheroFromJson(json);

  Map<String, dynamic> toJson() => _$SuperheroToJson(this);
}
