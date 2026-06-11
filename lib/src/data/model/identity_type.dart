class IdentityType {
  String? label;
  int? id;

  IdentityType({this.id, this.label});

  IdentityType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
  }

  bool get isAutre => label?.toLowerCase().contains("autre") ?? false;

  @override
  bool operator ==(Object other) {
    return other is IdentityType && other.id == id;
  }
}
