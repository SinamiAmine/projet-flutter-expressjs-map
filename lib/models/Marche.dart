class Marche {
  int? idMarche;
  String? numMarche;
  String? dateMarche;
  num? montantMarche;
  num? tauxRetenuGarantie;
  num? dejaPaye;
  String? dateDebutTravaux;
  String? dateFinTravaux;
  num? surfacePlancher;
  num? avancement;
  num? avancementAttache;
  num? seuilRetenueMarche;
  num? seuilPenaliteMarche;
  Object? operation;
  List<dynamic>? lotMarche;
  Object? directeur;
  Object? maitreOuvrage;

  Marche(
      {this.idMarche,
      this.numMarche,
      this.dateMarche,
      this.montantMarche,
      this.tauxRetenuGarantie,
      this.dejaPaye,
      this.dateDebutTravaux,
      this.dateFinTravaux,
      this.surfacePlancher,
      this.avancement,
      this.avancementAttache,
      this.seuilRetenueMarche,
      this.seuilPenaliteMarche,
      this.operation,
      this.lotMarche,
      this.directeur,
      this.maitreOuvrage});

  factory Marche.fromJson(Map<String, dynamic> json) {
    return Marche(
      idMarche: json['idMarche'] as int?,
      numMarche: json['numMarche'] as String?,
      dateMarche: json['dateMarche'] as String?,
      montantMarche: json['montantMarche'] as num?,
      tauxRetenuGarantie: json['tauxRetenuGarantie'] as num?,
      dejaPaye: json['dejaPaye'] as num?,
      dateDebutTravaux: json['dateDebutTravaux'] as String?,
      dateFinTravaux: json['dateFinTravaux'] as String?,
      surfacePlancher: json['surfacePlancher'] as num?,
      avancement: json['avancement'] as num?,
      avancementAttache: json['avancementAttache'] as num?,
      seuilRetenueMarche: json['seuilRetenueMarche'] as num?,
      seuilPenaliteMarche: json['seuilPenaliteMarche'] as num?,
      operation: json['operation'] as Object?,
      lotMarche: json['lotMarche'] as List<dynamic>?,
      directeur: json['directeur'] as Object?,
      maitreOuvrage: json['maitreOuvrage'] as Object?,
    );
  }
}
