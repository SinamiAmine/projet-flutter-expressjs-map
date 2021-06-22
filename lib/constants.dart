import 'package:flutter/material.dart';
import 'package:projectpfe/models/Marche.dart';
import 'package:projectpfe/models/Operation.dart';

import 'models/Foncier.dart';
import 'models/Projet.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;
const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);
const ipAddress = "192.168.1.65:5000";

List<Projet>? selectedProjets = [];
List<Foncier>? selectedFonciers = [];
List<Marche>? selectedMarches = [];
List<Operation>? selectedOperations = [];
Marche? selectedMarche;
Projet? selectedProjet;
Foncier? selectedFoncier;
Operation? selectedOperation;
