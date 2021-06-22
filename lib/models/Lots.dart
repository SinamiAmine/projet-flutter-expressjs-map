class LotsMarche {
  final String? id;
  final int? idLot;
  final String? designationLot;

  const LotsMarche({
    this.id,
    this.idLot,
    this.designationLot,
  });

  factory LotsMarche.fromJson(Map<String, dynamic> json) {
    return LotsMarche(
      id: json['_id'] as String?,
      idLot: json["idLot"] as int?,
      designationLot: json['designationLot'] as String?,
    );
  }
}
