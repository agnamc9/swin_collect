class Neighborhood {
  int? id;
  String? label;

  Neighborhood({this.id, this.label});

  Neighborhood.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['name'];
  }

  bool get isMarche => label?.toLowerCase().contains("march") ?? false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.label;
    return data;
  }
}
