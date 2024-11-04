import 'package:employee_manager_2/models/employee_vnos.dart';
import 'package:flutter/material.dart';

class Seznam extends StatefulWidget {
  const Seznam(
      {required this.employees,
      required this.onDelete,
      required this.onEdit,
      super.key});

  final List<Vnos> employees;
  final Function(Vnos)
      onDelete; //callback function za brisanje posameznega vnosa
  final Function(Vnos) onEdit; //funkcija za editanje

  @override
  State<Seznam> createState() => _SeznamState();
}

class _SeznamState extends State<Seznam> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.employees.length,
      itemBuilder: (_, index) {
        // Map workplaceIndex to the actual Workplace enum
        Workplace workplace =
            Workplace.values[widget.employees[index].workplaceIndex];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: workplace.color.withOpacity(0.5),
            ),
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.employees[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Text(widget.employees[index].surname,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Text(widget.employees[index].email,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),
                // Workplace title in delete icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: workplace.color,
                      ),
                      child: Text(workplace.title),
                    ),
                    IconButton(
                        onPressed: () {
                          widget.onEdit(widget.employees[index]);
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                      onPressed: () {
                        widget.onDelete(widget.employees[index]);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
