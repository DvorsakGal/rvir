import 'package:employee_manager_2/models/employee_vnos.dart';
import 'package:employee_manager_2/seznam.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  //Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(VnosAdapter());
  await Hive.openBox<Vnos>('vnosi');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Employee manager',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  //initialize hive box
  final Box<Vnos> _vnosBox = Hive.box<Vnos>('vnosi');

  // Employee currently being edited (if any)
  Vnos? currentlyEditingEmployee;

  // PRIVATNE SPREMENLJIVKE:
  final _formGlobalKey = GlobalKey<FormState>();
  Workplace _selectedWorkplace = Workplace.developer;
  String _name = "";
  String _surname = "";
  String _email = "";

  final List<Vnos> employees = [];

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _arrivalTimeController = TextEditingController();
  TextEditingController _departureTimeController = TextEditingController();

  TimeOfDay _selectedTime = TimeOfDay.now();

  MyAppState() {
    _loadEmployees();
  }

  void _loadEmployees() {
    employees.clear();
    employees.addAll(_vnosBox.values);
    notifyListeners();
  }

  void addEmployee(Vnos newEmployee) {
    _vnosBox.add(newEmployee);
    employees.add(newEmployee);
    notifyListeners();
  }

  void deleteEmployee(Vnos employee) {
    int index = employees.indexOf(employee);
    if (index != -1) {
      _vnosBox.delete(index); //remove from hive box
      employees.removeAt(index); //remove from list
      notifyListeners();
    }
  }

  void clearEmployees() {
    _vnosBox.clear();
    employees.clear();
    notifyListeners();
  }

  // EDIT EMPLOYEE
  void editEmployee(Vnos employee) {
    currentlyEditingEmployee = employee;
    _nameController.text = employee.name;
    _surnameController.text = employee.surname;
    _emailController.text = employee.email;
    _selectedWorkplace = Workplace.values[employee.workplaceIndex];

    notifyListeners();
  }

  // posodobi obstoječega zaposlenega
  void updateEmployee(Vnos updatedEmployee) {
    int index = employees.indexOf(currentlyEditingEmployee!);
    employees[index] = updatedEmployee;
    _vnosBox.putAt(index, updatedEmployee);
    currentlyEditingEmployee = null;
    notifyListeners();
  }

  // reset editing state after submission
  void resetForm() {
    currentlyEditingEmployee = null;
    _nameController.clear();
    _surnameController.clear();
    _emailController.clear();
    _selectedWorkplace = Workplace.developer;
    _dateController.clear();
    _arrivalTimeController.clear();
    _departureTimeController.clear();
    notifyListeners();
  }
}

//naredi starting page z navom
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Defining tabs within the build method
    final List<Widget> tabs = [
      HomeScreen(),
      EmployeeLogsScreen(onTabChange: switchTab),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Employer Manager"),
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// SCREENS

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // APP STATE
    var appState = context.watch<MyAppState>();

    // DVE SET METODI
    Future<void> _selectDate() async {
      DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime(2100),
      );

      if (_picked != null) {
        setState(() {
          appState._dateController.text = _picked.toString().split(" ")[0];
        });
      }
    }

    Future<void> _selectTime(TextEditingController myController) async {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: appState._selectedTime,
        initialEntryMode: TimePickerEntryMode.dial,
      );
      if (timeOfDay != null) {
        setState(() {
          appState._selectedTime = timeOfDay;
          // formatiranje časa
          final formattedTime = timeOfDay.format(context);
          myController.text = formattedTime;
        });
      }
    }

    //RETURN
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //Form
            Form(
              key: appState._formGlobalKey,
              child: Column(
                children: [
                  // ime
                  TextFormField(
                    controller: appState._nameController,
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
                      appState._name = newValue!;
                    },
                  ),

                  //priimek
                  TextFormField(
                    controller: appState._surnameController,
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
                      appState._surname = newValue!;
                    },
                  ),

                  //delovno mesto
                  DropdownButtonFormField(
                    value: appState._selectedWorkplace, //default workplace
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
                        appState._selectedWorkplace = value!;
                      });
                    },
                  ),

                  //email
                  TextFormField(
                    controller: appState._emailController,
                    decoration: const InputDecoration(
                      label: Text("Your email"),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please input your email";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      appState._email = newValue!;
                    },
                  ),

                  //Datum rojstva
                  TextFormField(
                    controller: appState._dateController,
                    decoration: const InputDecoration(
                      label: Text("Date of birth"),
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate();
                    },
                  ),

                  // Ura prihoda
                  TextFormField(
                    controller: appState._arrivalTimeController,
                    decoration: const InputDecoration(
                      label: Text("Arrival time"),
                      filled: true,
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectTime(appState._arrivalTimeController);
                    },
                  ),

                  // Ura odhoda
                  TextFormField(
                    controller: appState._departureTimeController,
                    decoration: const InputDecoration(
                      label: Text("Departure time"),
                      filled: true,
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectTime(appState._departureTimeController);
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //submit button
                  FilledButton(
                    onPressed: () {
                      if (appState._formGlobalKey.currentState!.validate()) {
                        appState._formGlobalKey.currentState!.save();

                        final newEmployee = Vnos(
                            name: appState._name,
                            surname: appState._surname,
                            workplaceIndex: appState._selectedWorkplace.index,
                            email: appState._email);

                        if (appState.currentlyEditingEmployee != null) {
                          appState.updateEmployee(newEmployee);
                        } else {
                          appState.addEmployee(newEmployee);
                        }

                        appState.resetForm();
                        /*
                        appState._formGlobalKey.currentState!.reset();
                        appState._selectedWorkplace = Workplace.developer;
                        appState._dateController.clear();
                        appState._arrivalTimeController.clear();
                        appState._departureTimeController.clear();
                        */
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(appState.currentlyEditingEmployee == null
                        ? "Submit"
                        : "Update"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeLogsScreen extends StatelessWidget {
  final Function(int) onTabChange;

  EmployeeLogsScreen({required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.employees.isEmpty) {
      return const Center(
        child: Text("No entries yet"),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Seznam(
              employees: appState.employees,
              onDelete: (employee) {
                appState.deleteEmployee(employee);
              },
              onEdit: (employee) {
                appState.editEmployee(
                    employee); // Load employee data into form for editing
                onTabChange(0);
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              appState.clearEmployees();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              "Delete All Entries",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
