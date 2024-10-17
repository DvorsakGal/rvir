import 'package:flutter/material.dart';

enum Workplace {
  developer(color: Colors.red, title: "Dev"),
  tester(color: Colors.blueAccent, title: "QA"),
  productOwner(color: Colors.lightGreen, title: "PO"),
  manager(color: Colors.pink, title: "Manager"),
  it(color: Colors.amber, title: "IT");

  final Color color;
  final String title;

  const Workplace({required this.color, required this.title});
}

class Vnos {
  final String name;
  final String surname;
  final Workplace workplace;

  const Vnos(
      {required this.name, required this.surname, required this.workplace});
}
