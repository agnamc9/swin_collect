class CashierStatus {
  int? id;
  // List<Null>? collector;
  // List<Null>? zone;
  String? date;
  num? totalTheorique;
  // Null? montantPhysique;
  // Null? ecart;
  String? statut;
  String? openedAt;
  // Null? closedAt;
  bool? closedAutomatically;

  CashierStatus({
    this.id,
    // this.collector,
    // this.zone,
    this.date,
    this.totalTheorique,
    // this.montantPhysique,
    // this.ecart,
    this.statut,
    this.openedAt,
    // this.closedAt,
    this.closedAutomatically,
  });

  CashierStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // if (json['collector'] != null) {
    //   collector = <Null>[];
    //   json['collector'].forEach((v) {
    //     collector!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['zone'] != null) {
    //   zone = <Null>[];
    //   json['zone'].forEach((v) {
    //     zone!.add(new Null.fromJson(v));
    //   });
    // }
    date = json['date'];
    totalTheorique = json['totalTheorique'];
    // montantPhysique = json['montantPhysique'];
    // ecart = json['ecart'];
    statut = json['statut'];
    openedAt = json['openedAt'];
    // closedAt = json['closedAt'];
    closedAutomatically = json['closedAutomatically'];
  }

  bool get isOpen => statut?.toLowerCase().contains("ouvert") ?? false;
}
