class Directeur {
  final String? id;
  final num? code;
  final num? matricule;
  final String? nom;
  final String? prenom;
  final String? numCin;
  final num? codeFonction;
  final String? telephone;
  final String? email;
  final String? dateNaiss;
  final String? dateEmbauche;
  final num? prixParHeure;
  final num? numCnss;

  const Directeur({
    this.id,
    this.code,
    this.matricule,
    this.nom,
    this.prenom,
    this.numCin,
    this.codeFonction,
    this.telephone,
    this.email,
    this.dateNaiss,
    this.dateEmbauche,
    this.prixParHeure,
    this.numCnss,
  });

  factory Directeur.fromJson(Map<String, dynamic> json) {
    return Directeur(
      id: json["_id"] as String?,
      code: json['code'] as num?,
      matricule: json['matricule'] as num?,
      nom: json['nom'] as String?,
      prenom: json['prenom'] as String?,
      numCin: json['numCin'] as String?,
      telephone: json['telephone'] as String?,
      email: json['email'] as String?,
      dateNaiss: json['dateNaiss'] as String?,
      dateEmbauche: json['dateEmbauche'] as String?,
      prixParHeure: json['prixParHeure'] as num?,
      numCnss: json['numCnss'] as num?,
    );
  }
}
