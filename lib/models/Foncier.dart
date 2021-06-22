class Foncier {
  final String? id;
  final num? codeFoncier;
  final String? localite;
  final String? titreFoncier;
  final String? denomination;
  final String? etat;
  final num? latitude;
  final num? longitude;
  final String? observation;
  final num? surfaceTf;
  final String? ville;

  const Foncier({
    this.id,
    this.codeFoncier,
    this.localite,
    this.titreFoncier,
    this.denomination,
    this.etat,
    this.latitude,
    this.longitude,
    this.observation,
    this.surfaceTf,
    this.ville,
  });

  factory Foncier.fromJson(Map<String, dynamic> json) {
    return Foncier(
      id: json["_id"] as String?,
      codeFoncier: json['codeFoncier'] as num?,
      localite: json['localite'] as String?,
      titreFoncier: json['titreFoncier'] as String?,
      denomination: json['denomination'] as String?,
      etat: json['etat'] as String?,
      latitude: json['latitude'] as num?,
      longitude: json['longitude'] as num?,
      observation: json['observation'] as String?,
      surfaceTf: json['surfaceTf'] as num?,
      ville: json['ville'] as String?,
    );
  }
}
