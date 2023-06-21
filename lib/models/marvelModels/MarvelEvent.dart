

import 'package:marvel_api_app/models/marvelModels/ImageObjectModel.dart';

class MarvelEvent {
  final int id;
  final String title;
  final String description;
  final String resourceURI;
  final ImageObject thumbnail;

  MarvelEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.resourceURI,
    required this.thumbnail,
  });

  factory MarvelEvent.fromJson(Map<String, dynamic> json) {
    return MarvelEvent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      resourceURI: json['resourceURI'],
      thumbnail: ImageObject.fromJson(Map<String, dynamic>.from(json['thumbnail'])),
    );
  }
}
