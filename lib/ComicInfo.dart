import 'package:flutter/material.dart';
import 'package:marvel_api_app/services/marvel_api_client.dart';
import 'package:marvel_api_app/services/md5_api_client.dart';

import 'models/marvelModels/ComicDataModel.dart';
import 'models/marvelModels/CreatorInfoModel.dart';
import 'models/marvelModels/ImageObjectModel.dart';
import 'models/md5Model.dart';


String publicKey = "df460e7b04d986419acf029680a28d60";
String privateKey = "ebbc27080f123549ff61d4eb5101bad61f4bac26";

class ComicInfo extends StatefulWidget {
  const ComicInfo({Key? key, required this.comic}) : super(key: key);

  final ComicData comic;

  @override
  State<ComicInfo> createState() => _ComicInfoState();
}

class _ComicInfoState extends State<ComicInfo> {
  Md5Client md5Client = Md5Client();
  MarvelApiClient marvelClient = MarvelApiClient();
  int _widgetIndex = 0;
  CreatorInfo? creator;


  void _retrieveCreator(String creatorUrl) async {
    Md5 hashResponse = await md5Client.getMd5Data(publicKey, privateKey);

    print(
        "[HomePage][_retrieveCreator] - Printing getMd5Data result with hash: ${hashResponse
            .md5hash} and timestamp ${hashResponse.timeStamp}");
    CreatorInfo retrievedCreator = await marvelClient.getCreatorInfo(
        hashResponse.timeStamp!, publicKey, hashResponse.md5hash!, creatorUrl);
    setState(() {
      creator = retrievedCreator;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _retrieveCreator(widget.comic.collectionURI!);
  }

  String handleImageConstruction(ImageObject img) {
    return '${img.path}.${img.extension}';
  }

  Widget handleComicImages(List<ImageObject> comicCovers) {
    if (comicCovers.isEmpty) {
      print('[_ComicInfoState][handleComicImages] no images found');
      return Image.network(
        "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg",
        fit: BoxFit.fitWidth,);
    } else if (comicCovers.length <= 1) {
      print(
          '[_ComicInfoState][handleComicImages] only 1 image found for comic cover');
      return Image.network(
        handleImageConstruction(comicCovers.first), fit: BoxFit.fitWidth,);
    } else {
      print(
          '[_ComicInfoState][handleComicImages] found ${comicCovers
              .length} covers');

      return Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (_widgetIndex == comicCovers.length - 1) {
                  _widgetIndex = 0;
                } else {
                  _widgetIndex++;
                }
              });
            },
            child: IndexedStack(
                index: _widgetIndex,
                children: comicCovers
                    .map((img) =>
                    Image.network(
                        handleImageConstruction(img), fit: BoxFit.fitWidth))
                    .toList()),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.comic.title!),
      ),
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(15),
              child: ListView(
                children: <Widget>[
                  handleComicImages(widget.comic.images),
                  if(widget.comic.images.length > 1) Row(
                    children: [
                      const Icon(Icons.label_important_sharp, size: 14,),
                      const SizedBox(width: 12,),
                      Text(
                        '${widget.comic.images
                            .length} covers available. Tap to see the next cover.',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  const SizedBox(width: 35),
                  Padding(padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: Text(widget.comic.title!, style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.clip)),
                  const SizedBox(width: 35),
                  Row(
                    children: [
                      SizedBox(
                          width: 75,
                          height: 75,
                          child: creator != null? Image.network(
                              handleImageConstruction(creator!.image)) : const Text('No creator image found')),
                      creator != null?  Text(creator!.fullName, style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w200)) : Text('No creator name found')
                    ],
                  ),
                  const SizedBox(width: 35),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Pages: ${widget.comic.pageCount}"),
                        Text("Price: \$${widget.comic.price.price}"),
                        // replace with price
                      ],
                    ),),
                  const SizedBox(height: 15),
                  Text("Description. - ${widget.comic.description ??
                      "No description found"}"),
                ],
              ))),
    );
  }
}
