import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projectpfe/constants.dart';
import 'package:projectpfe/models/Projet.dart';

class Services {
  static getProjets() async {
    try {
      var map = Map<String, dynamic>();
      final response = await http.post(Uri.parse(ipAddress + "/projets"));
      print('getProjets Response: ${response.body}');
      print('getProjets length: ${response.body.length}');
      if (200 == response.statusCode) {
        List<Projet>? list = json.decode(response.body);
        return list;
      } else {
        return <Projet>[];
      }
    } catch (e) {
      return <Projet>[]; // return an empty list on exception/error

    }
  }

  static List<Projet>? parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Projet>((json) => Projet.fromJson(json)).toList();
  }
}
