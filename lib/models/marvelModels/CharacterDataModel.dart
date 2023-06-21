

class CharacterData {
  int? id;
  String? name, photo;

  CharacterData(this.id, this.name, this.photo) {
    print('Character Details: $name, imgUrl: $photo with ID: $id');
  }

  CharacterData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    String path = json['thumbnail']['path'];
    String extension = json['thumbnail']['extension'];
    photo = Uri.parse("$path.$extension").toString();
  }
}


