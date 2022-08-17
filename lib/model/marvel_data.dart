class Result {
  String? name;

  Result(this.name);

  factory Result.fromJson(dynamic json) {
    return Result(json['name'] as String);
  }
}

class Data {
  List<Result>? results;

  Data([this.results]);

  factory Data.fromJson(dynamic json) {
    if (json['results'] != null) {
      var resultsJson = json['results'] as List;
      List<Result> _result = resultsJson.map((resultJson) =>
          Result.fromJson(resultJson)).toList();

      return Data(_result);
    } else {
      return Data(List.empty());
    }
  }
}

class MarvelData {
  Data? data;

  MarvelData({this.data});

  MarvelData.fromJson(dynamic json) {
    data = json["data"];
  }
}


class CharacterData {
  int? id;
  String? name, photo;

  CharacterData(this.id, this.name, this.photo) {
    print('Character Details: $name, imgUrl: $photo with ID: $id');
  }
}

class ComicData {
  int? id;
  String? title, photo;

  ComicData(this.id, this.title, this.photo){
    print('Comic Details: $title, imgUrl: $photo with ID: $id');
  }
}

