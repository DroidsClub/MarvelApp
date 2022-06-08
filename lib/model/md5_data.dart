class Md5 {
  String? md5hash;
  String? timeStamp;

  Md5({
  this.md5hash,
  this.timeStamp});

  Md5.fromJson(Map<String, dynamic> json) {
    md5hash = json["md5hash"];
    timeStamp = json["timeStamp"];
}
}