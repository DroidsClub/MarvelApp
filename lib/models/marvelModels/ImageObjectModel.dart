
class ImageObject {
  String? path;
  String? extension;

  ImageObject(this.path, this.extension) {
    print('Img url: $path.$extension');
  }

  ImageObject.fromJson(Map<String, dynamic> json)
      : path = json['path'],
        extension = json['extension'];

  String get imageAssetUrl => '$path.$extension';
}