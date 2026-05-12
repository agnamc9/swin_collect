class TaxType {
  int? id;
  String? typeTaxe;
  String? typeTaux;
  String? assiette;
  String? periodicite;
  double? taux;

  TaxType({this.id, this.typeTaxe, this.typeTaux, this.assiette, this.periodicite, this.taux});

  TaxType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeTaxe = json['typeTaxe'];
    typeTaux = json['typeTaux'];
    assiette = json['assiette'];
    periodicite = json['periodicite'];
    taux = json['taux'];
  }

  bool get isOdp => typeTaux!.toLowerCase().contains("odp");

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['typeTaxe'] = this.typeTaxe;
    data['typeTaux'] = this.typeTaux;
    data['assiette'] = this.assiette;
    data['periodicite'] = this.periodicite;
    data['taux'] = this.taux;
    return data;
  }
}
