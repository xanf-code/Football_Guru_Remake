import 'package:flutter/material.dart';

String selectedValue = "league";
String selectedType = "rating";

List<DropdownMenuItem<String>> dropDownItem() {
  List<String> ddl = ["league", "semi_final", "final"];
  return ddl
      .map((value) => DropdownMenuItem(
            value: value,
            child: Text(value),
          ))
      .toList();
}

List<DropdownMenuItem<String>> ISLStatsItems() {
  List<String> isl = [
    "goals",
    "goal_assist",
    "rating",
    "mins_played_goal",
    "total_att_assist",
    "big_chance_created",
    "accurate_pass",
    "clean_sheet",
    "saves",
    "effective_clearance",
    "won_tackle",
    "yellow_card",
    "red_card",
  ];
  return isl
      .map((value) => DropdownMenuItem(
            value: value,
            child: Text(value),
          ))
      .toList();
}

String selectedLeague;
List<DropdownMenuItem<String>> favLeagueList() {
  List<String> isl = [
    "Indian Super League",
    "I-League",
  ];
  return isl
      .map((value) => DropdownMenuItem(
            value: value,
            child: Text(value),
          ))
      .toList();
}
