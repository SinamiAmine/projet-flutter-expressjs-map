class Avancement {
  String? id;
  num? idAvancement;
  String? dateAvancement;
  num? tauxRealiseMarche;
  num? montantRealiseMarche;
  num? montantPrevuMarche;
  num? montantRealiseMarcheAncien;
  num? tauxRealiseMarcheAncien;
  num? retenueMalFaconMarche;
  Object? marche;

  Avancement(
      {this.id,
      this.idAvancement,
      this.dateAvancement,
      this.tauxRealiseMarche,
      this.montantRealiseMarche,
      this.montantPrevuMarche,
      this.montantRealiseMarcheAncien,
      this.tauxRealiseMarcheAncien,
      this.retenueMalFaconMarche,
      this.marche});

  factory Avancement.fromJson(Map<String, dynamic> json) {
    return Avancement(
      id: json["_id"] as String?,
      idAvancement: json['idAvancement'] as num?,
      dateAvancement: json['dateAvancement'] as String?,
      tauxRealiseMarche: json['tauxRealiseMarche'] as num?,
      montantRealiseMarche: json['montantRealiseMarche'] as num?,
      montantPrevuMarche: json['montantPrevuMarche'] as num?,
      montantRealiseMarcheAncien: json['montantRealiseMarcheAncien'] as num?,
      tauxRealiseMarcheAncien: json['tauxRealiseMarcheAncien'] as num?,
      retenueMalFaconMarche: json['retenueMalFaconMarche'] as num?,
      marche: json['marche'] as Object?,
    );
  }
}
