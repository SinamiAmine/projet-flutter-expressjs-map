class Maitre {
  final String? id;
  final num? codeMaitreOuvrage;
  final String? raisonSocial;
  final String? telephone;
  final String? mobile;
  final String? ville;
  final String? adresse;
  final String? email;

  const Maitre({
    this.id,
    this.codeMaitreOuvrage,
    this.raisonSocial,
    this.telephone,
    this.mobile,
    this.ville,
    this.adresse,
    this.email,
  });

  factory Maitre.fromJson(Map<String, dynamic> json) {
    return Maitre(
      id: json["_id"] as String?,
      codeMaitreOuvrage: json['codeMaitreOuvrage'] as num?,
      raisonSocial: json['raisonSocial'] as String?,
      telephone: json['telephone'] as String?,
      mobile: json['mobile'] as String?,
      ville: json['ville'] as String?,
      adresse: json['adresse'] as String?,
      email: json['email'] as String?,
    );
  }
}
