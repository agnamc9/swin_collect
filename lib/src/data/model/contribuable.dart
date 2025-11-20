import 'model.dart';

class Contribuable {
  int? id;
  String? matricule;
  String? firstname;
  String? lastname;
  String? address;
  String? ville;
  String? phoneNumber;
  String? idIdentity;
  String? photoPath;
  String? createdAt;
  String? identityType;
  String? longitude;
  String? latitude;
  String? activite;
  Tax? tax;

  Contribuable({
    this.id,
    this.matricule,
    this.firstname,
    this.lastname,
    this.address,
    this.ville,
    this.phoneNumber,
    this.idIdentity,
    this.photoPath,
    this.createdAt,
    this.identityType,
    this.longitude,
    this.latitude,
    this.activite,
    this.tax,
  });

  Contribuable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    matricule = json['matricule'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    address = json['address'];
    ville = json['ville'];
    phoneNumber = json['phoneNumber'];
    idIdentity = json['idIdentity'];
    photoPath = json['photoPath'];
    createdAt = json['createdAt'];
    identityType = json['identityType'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    activite = json['activite'];
    tax = json['tax'] != null ? Tax.fromJson(json['tax']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['matricule'] = matricule;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['address'] = address;
    data['ville'] = ville;
    data['phoneNumber'] = phoneNumber;
    data['idIdentity'] = idIdentity;
    data['photoPath'] = photoPath;
    data['createdAt'] = createdAt;
    data['identityType'] = identityType;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['activite'] = activite;
    if (tax != null) {
      data['tax'] = tax!.toJson();
    }
    return data;
  }
}
