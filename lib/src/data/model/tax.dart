class Tax {
  int? id;

  //List<Null>? categorie;
  String? natureTaxe;
  String? typeTaux;
  String? assiette;
  String? periodicite;
  double? taux;

  Tax({
    this.id,
    //this.categorie,
    this.natureTaxe,
    this.typeTaux,
    this.assiette,
    this.periodicite,
    this.taux,
  });

  Tax.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    /*if (json['categorie'] != null) {
      categorie = <Null>[];
      json['categorie'].forEach((v) {
        categorie!.add(new Null.fromJson(v));
      });
    }*/
    natureTaxe = json['natureTaxe'];
    typeTaux = json['typeTaux'];
    assiette = json['assiette'];
    periodicite = json['periodicite'];
    taux = json['taux'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    /*if (this.categorie != null) {
      data['categorie'] = this.categorie!.map((v) => v.toJson()).toList();
    }*/
    data['natureTaxe'] = this.natureTaxe;
    data['typeTaux'] = this.typeTaux;
    data['assiette'] = this.assiette;
    data['periodicite'] = this.periodicite;
    data['taux'] = this.taux;
    return data;
  }
}
