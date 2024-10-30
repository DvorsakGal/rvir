import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'employee_vnos.g.dart';

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

@HiveType(typeId: 0)
class Vnos {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String surname;
  @HiveField(3)
  final int workplaceIndex;
  @HiveField(4)
  final String email;

  const Vnos(
      {required this.name,
      required this.surname,
      required this.workplaceIndex,
      required this.email});

  Workplace getWorkplace() => Workplace.values[workplaceIndex];
}
