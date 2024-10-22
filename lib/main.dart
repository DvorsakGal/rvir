import 'package:employee_manager_2/models/employee_vnos.dart';
import 'package:employee_manager_2/seznam.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
  // PRIVATNE SPREMENLJIVKE:
  final _formGlobalKey = GlobalKey<FormState>();
  Workplace _selectedWorkplace = Workplace.developer;
  String _name = "";
  String _surname = "";

  final List<Vnos> employees = [];

  TextEditingController _dateController = TextEditingController();
  TextEditingController _arrivalTimeController = TextEditingController();
  TextEditingController _departureTimeController = TextEditingController();

  TimeOfDay _selectedTime = TimeOfDay.now();
}

//naredi starting page z navom
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    HomeScreen(),
    EmployeeLogsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employer Manager"),
      ),
      body: _tabs[_currentIndex],
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

                        setState(() {
                          appState.employees.add(Vnos(
                            name: appState._name,
                            surname: appState._surname,
                            workplace: appState._selectedWorkplace,
                          ));
                        });

                        appState._formGlobalKey.currentState!.reset();
                        appState._selectedWorkplace = Workplace.developer;
                        appState._dateController.clear();
                        appState._arrivalTimeController.clear();
                        appState._departureTimeController.clear();
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
          ],
        ),
      ),
    );
  }
}

class EmployeeLogsScreen extends StatelessWidget {
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
            child: Seznam(employees: appState.employees),
          ),
        ],
      ),
    );
  }
}
