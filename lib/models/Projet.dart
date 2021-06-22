class Projet {
  String? id;
  int? idProjet;
  String? nomProjet;
  int? surfaceTitreFoncier;
  int? surfacePlancher;
  int? surfaceLoti;
  int? delai;
  int? budget;
  String? numAutorisationConstruire;
  String? dateAutorisationConstruire;
  String? numAutorisationLotir;
  String? dateAutorisationLotir;
  String? observation;
  Object? maitreOuvrage;
  Object? directeur;
  Object? foncier;

  Projet(
      {this.id,
      this.idProjet,
      this.nomProjet,
      this.surfaceTitreFoncier,
      this.surfacePlancher,
      this.surfaceLoti,
      this.delai,
      this.budget,
      this.numAutorisationConstruire,
      this.dateAutorisationConstruire,
      this.numAutorisationLotir,
      this.dateAutorisationLotir,
      this.observation,
      this.maitreOuvrage,
      this.directeur,
      this.foncier});

  factory Projet.fromJson(Map<String, dynamic> json) {
    return Projet(
      id: json["_id"] as String?,
      idProjet: json['idProjet'] as int?,
      nomProjet: json['nomProjet'] as String?,
      surfaceTitreFoncier: json['surfaceTitreFoncier'] as int?,
      surfacePlancher: json['surfacePlancher'] as int?,
      surfaceLoti: json['surfaceLoti'] as int?,
      delai: json['delai'] as int?,
      budget: json['budget'] as int?,
      numAutorisationConstruire: json['numAutorisationConstruire'] as String?,
      dateAutorisationConstruire: json['dateAutorisationConstruire'] as String?,
      numAutorisationLotir: json['numAutorisationLotir'] as String?,
      dateAutorisationLotir: json['dateAutorisationLotir'] as String?,
      observation: json['observation'] as String?,
      maitreOuvrage: json['maitreOuvrage'] as Object?,
      directeur: json['directeur'] as Object?,
      foncier: json['foncier'] as Object?,
    );
  }
}
