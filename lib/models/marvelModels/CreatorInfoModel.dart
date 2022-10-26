import 'ImageObjectModel.dart';

class CreatorInfo {
  String fullName;
  ImageObject image;

  CreatorInfo(this.fullName, this.image);

  CreatorInfo.fromJson(Map<String, dynamic> json)
      : fullName = json['fullName'],
        image = ImageObject.fromJson(json['thumbnail']);
}