import 'package:employee_manager_2/models/employee_vnos.dart';
import 'package:employee_manager_2/seznam.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formGlobalKey = GlobalKey<FormState>();
  Workplace _selectedWorkplace = Workplace.developer;
  String _name = "";
  String _surname = "";

  final List<Vnos> employees = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Manager"),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //Form
            Form(
              key: _formGlobalKey,
              child: Column(
                children: [
                  // ime
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Your name"),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please input your name";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _name = newValue!;
                    },
                  ),

                  //priimek
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Your surname"),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please input your surname";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _surname = newValue!;
                    },
                  ),

                  //delovno mesto
                  DropdownButtonFormField(
                    value: _selectedWorkplace, //default workplace
                    decoration: const InputDecoration(
                      label: Text("Choose your workplace"),
                    ),
                    items: Workplace.values.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Text(p.title),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedWorkplace = value!;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //submit button
                  FilledButton(
                    onPressed: () {
                      if (_formGlobalKey.currentState!.validate()) {
                        _formGlobalKey.currentState!.save();

                        setState(() {
                          employees.add(Vnos(
                            name: _name,
                            surname: _surname,
                            workplace: _selectedWorkplace,
                          ));
                        });

                        _formGlobalKey.currentState!.reset();
                        _selectedWorkplace = Workplace.developer;
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text("Submit"),
                  )
                ],
              ),
            ),

            //Seznam
            Expanded(
              child: Seznam(employees: employees),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.grey,
        child: Row(
          children: [Text("Home"), Text("Employees")],
        ),
      ),
    );
  }
}
