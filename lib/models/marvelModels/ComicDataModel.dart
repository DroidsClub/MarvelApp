
import 'package:flutter/material.dart';

import 'ImageObjectModel.dart';

class ComicData {
  int? id, pageCount;
  String? title, description, collectionURI;
  late ComicPrice price;
  late List<ImageObject> images;

  ComicData(this.id, this.pageCount, this.title, this.description, this.images, this.collectionURI, this.price);

  ComicData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pageCount = json['pageCount'];
    title = json['title'];
    description = json['description'];
    collectionURI = json['creators']['collectionURI'];
    Iterable resultsJson = json['images'] as List;
    List<ImageObject> resultImages = resultsJson.map((image) =>
        ImageObject.fromJson(image)).toList();
    images = resultImages;
    Iterable priceResultsJson = json['prices'] as List;
    List<ComicPrice> prices = priceResultsJson.map((price) =>
        ComicPrice.fromJson(price)).toList();
    price = prices.first;
  }
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

class ComicPrice {
  String? type;
  double? price;

  ComicPrice(this.type, this.price);

  ComicPrice.fromJson(Map<String, dynamic> json){
    type = json['type'];

    try{
      price = json['price'];
    }catch(e){
      print('price not found error: $e');
      price = 0.00;
    }
  }
}
