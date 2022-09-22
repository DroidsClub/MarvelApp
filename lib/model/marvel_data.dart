import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class Result {
//   String? name;
//
//   Result(this.name);
//
//   factory Result.fromJson(dynamic json) {
//     return Result(json['name'] as String);
//   }
// }
//
// class Data {
//   List<Result>? results;
//
//   Data([this.results]);
//
//   factory Data.fromJson(dynamic json) {
//     if (json['results'] != null) {
//       var resultsJson = json['results'] as List;
//       List<Result> _result = resultsJson.map((resultJson) =>
//           Result.fromJson(resultJson)).toList();
//
//       return Data(_result);
//     } else {
//       return Data(List.empty());
//     }
//   }
// }
//
// class MarvelData {
//   Data? data;
//
//   MarvelData({this.data});
//
//   MarvelData.fromJson(dynamic json) {
//     data = json["data"];
//   }
// }


class CharacterData {
  int? id;
  String? name, photo;

  CharacterData(this.id, this.name, this.photo) {
    print('Character Details: $name, imgUrl: $photo with ID: $id');
  }
}

// class ComicData {
//   int? id;
//   String? title, path, extension;
//
//   ComicData(this.id, this.title, this.path, this.extension) {
//     print('Comic Details: $title, imgUrl: $path.$extension with ID: $id');
//   }
//
//   ComicData.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         title = json['title'],
//         path = json['images'][0]['path'],
//         extension = json['images'][0]['extension'];
// }

class ComicData {
  int? id, pageCount;
  String? title, description, collectionURI;
  late List<ImageObject> images;

  ComicData(this.id, this.pageCount, this.title, this.description, this.images, this.collectionURI);

  // ComicData.fromJson(Map<String, dynamic> json)
  //     : id = json['id'],
  //       title = json['title'],
  //       images =  json['images'];

  ComicData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pageCount = json['pageCount'];
    title = json['title'];
    description = json['description'];
    print('Collection URI??? -> '+  json['creators']['collectionURI']);
    collectionURI = json['creators']['collectionURI'];
    Iterable resultsJson = json['images'] as List;
    List<ImageObject> resultImages = resultsJson.map((image) =>
        ImageObject.fromJson(image)).toList();
    images = resultImages;
  }
}

class ImageObject {
  String? path;
  String? extension;

  ImageObject(this.path, this.extension) {
    print('Img url: $path.$extension');
  }

  ImageObject.fromJson(Map<String, dynamic> json)
      : path = json['path'],
        extension = json['extension'];
}

abstract class ListItem {

  Widget buildImage(BuildContext context);

  Widget buildTitle(BuildContext context);

}

class ComicItem implements ListItem {
  final List<ImageObject> images;
  final String title;

  ComicItem(this.images, this.title);

  Widget getImageToShow(BuildContext context) {
    if (images.isNotEmpty) {
      return buildImage(context);
    } else {
      return buildNoImageFound(context);
    }
  }

  String buildImgUrl(ImageObject img) {
    return '${img.path}.${img.extension}';
  }

  Widget buildNoImageFound(BuildContext context) =>
      Image.network(
          "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg",
      loadingBuilder: (context, child, progress) {
       return progress == null ? child : const LinearProgressIndicator();
      });

  @override
  Widget buildImage(BuildContext context) =>
      Image.network(buildImgUrl(images.first));

  @override
  Widget buildTitle(BuildContext context) => Text(title, style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.clip));

}

class CreatorInfo {
  String fullName;
  ImageObject image;

  CreatorInfo(this.fullName, this.image);

  CreatorInfo.fromJson(Map<String, dynamic> json)
    : fullName = json['fullName'],
      image = ImageObject.fromJson(json['thumbnail']);
}

