// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'powerstats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Powerstats _$PowerStatsFromJson(Map<String, dynamic> json) => Powerstats(
      json['intelligence'] as String,
      json['strength'] as String,
      json['speed'] as String,
      json['durability'] as String,
      json['power'] as String,
      json['combat'] as String,
    );

Map<String, dynamic> _$PowerStatsToJson(Powerstats instance) => <String, dynamic>{
      'intelligence': instance.intelligence,
      'strength': instance.strength,
      'speed': instance.speed,
      'durability': instance.durability,
      'power': instance.power,
      'combat': instance.combat,
    };
