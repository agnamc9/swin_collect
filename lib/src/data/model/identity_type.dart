class IdentityType {
  String? label;
  int? id;

  IdentityType({this.id, this.label});

  IdentityType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
  }
}
