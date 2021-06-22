class Operation {
  String? id;
  num? idOperation;
  String? nomOperation;
  num? surfaceTitreFoncier;
  num? surfacePlancher;
  num? surfaceLoti;
  num? delai;
  num? budget;
  String? numAutorisationConstruire;
  String? dateAutorisationConstruire;
  String? numAutorisationLotir;
  String? dateAutorisationLotir;
  Object? foncier;
  Object? projet;
  Object? maitre;
  Object? directeur;

  Operation(
      {this.id,
      this.idOperation,
      this.nomOperation,
      this.surfaceTitreFoncier,
      this.surfacePlancher,
      this.surfaceLoti,
      this.delai,
      this.budget,
      this.numAutorisationConstruire,
      this.dateAutorisationConstruire,
      this.numAutorisationLotir,
      this.dateAutorisationLotir,
      this.foncier,
      this.projet,
      this.maitre,
      this.directeur});

  factory Operation.fromJson(Map<String, dynamic> json) {
    return Operation(
      id: json["_id"] as String,
      idOperation: json['idOperation'] as num?,
      nomOperation: json['nomOperation'] as String?,
      surfaceTitreFoncier: json['surfaceTitreFoncier'] as num?,
      surfacePlancher: json['surfacePlancher'] as num?,
      surfaceLoti: json['surfaceLoti'] as num?,
      delai: json['delai'] as num?,
      budget: json['budget'] as num?,
      numAutorisationConstruire: json['numAutorisationConstruire'] as String?,
      dateAutorisationConstruire: json['dateAutorisationConstruire'] as String?,
      numAutorisationLotir: json['numAutorisationLotir'] as String?,
      dateAutorisationLotir: json['dateAutorisationLotir'] as String?,
      foncier: json['foncier'] as Object?,
      projet: json['projet'] as Object?,
      maitre: json['maitreOuvrage'] as Object?,
      directeur: json['directeur'] as Object?,
    );
  }
}
