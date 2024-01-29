import 'package:json_annotation/json_annotation.dart';

part 'server_image.g.dart';

@JsonSerializable()
class ServerImage {
  final String url;

  const ServerImage(this.url);

  factory ServerImage.fromJson(final Map<String, dynamic> json) => _$ServerImageFromJson(json);

  Map<String, dynamic> toJson() => _$ServerImageToJson(this);
}
