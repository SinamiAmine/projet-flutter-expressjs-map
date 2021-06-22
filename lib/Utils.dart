import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/Projet.dart';

class Utils {
  static showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static List<T> modelBuilder<M, T>(
          List<M> models, T Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, T>((index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();

  static Future loadCountries() async {
    final data = await rootBundle.loadString('assets/country_codes.json');
    final countriesJson = json.decode(data);

    return countriesJson.keys.map<Projet>((code) {
      final json = countriesJson[code];
      final newJson = json..addAll({'code': code.toLowerCase()});

      return Projet.fromJson(newJson);
    }).toList()
      ..sort(Utils.ascendingSort);
  }

  static int ascendingSort(Projet c1, Projet c2) =>
      c1.nomProjet!.compareTo(c2.nomProjet!);
}
