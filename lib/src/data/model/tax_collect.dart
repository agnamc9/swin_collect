class TaxCollect {
  int? id;
  String? paymentNumber;
  String? collectedAt;
  int? amountCollected;
  Map<String, dynamic>? contribuable;

  TaxCollect({
    this.id,
    this.paymentNumber,
    this.collectedAt,
    this.amountCollected,
    this.contribuable,
  });

  TaxCollect.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentNumber = json['paymentNumber'];
    collectedAt = json['collectedAt'];
    amountCollected = json['amountCollected'];
    contribuable = json['contribuable'];
  }

  int? get contribuableId => contribuable?['id'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['paymentNumber'] = this.paymentNumber;
    data['collectedAt'] = this.collectedAt;
    data['amountCollected'] = this.amountCollected;
    return data;
  }
}
