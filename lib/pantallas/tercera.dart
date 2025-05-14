import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

//Heredamos de un Stateful para poder modificar los colores
class Tercera extends StatefulWidget {
  @override
  TerceraPantallaState createState() => TerceraPantallaState();
}

//Herencia del Stateful
class TerceraPantallaState extends State<Tercera> {
  Color colorElegido = Colors.blue;
  TextEditingController _controladorTextoCita = TextEditingController();
  DateTime _incioCita = DateTime.now();
  DateTime _finalCita = DateTime.now();
  bool? _todoDia = true;

  void agendarCita(context, colorSeleccionado, encabezadoCita, fechaInicio, fechaFin){
    print("Titulo cita " + encabezadoCita);
    print("Inicio cita " + fechaInicio.toString());
    print("Final cita " + fechaFin.toString());
    print("Color " + colorSeleccionado);
    Navigator.pop(context, 'OK');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SfCalendar(
          view: CalendarView.month,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Agenda tu cita'),
            content: Column(
              children: [
                TextField(
                  controller: _controladorTextoCita,
                  decoration: InputDecoration(
                    labelText : "Titulo de cita",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text("Inicio cita"),
                CupertinoCalendarPickerButton(
                  minimumDateTime: DateTime(2024, 7, 10),
                  maximumDateTime: DateTime(2025, 7, 10),
                  initialDateTime: DateTime(2024, 8, 15, 9, 41),
                  currentDateTime: DateTime.now(),
                  mode: CupertinoCalendarMode.dateTime,
                  timeLabel: 'Start',
                  onDateTimeChanged: (date) {
                    _incioCita = date; //Asignamos la fecha de inicio a la cita
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text("Final cita"),
                CupertinoCalendarPickerButton(
                  minimumDateTime: DateTime(2024, 7, 10),
                  maximumDateTime: DateTime(2025, 7, 10),
                  initialDateTime: DateTime(2024, 8, 15, 9, 41),
                  currentDateTime: DateTime(2024, 8, 15),
                  mode: CupertinoCalendarMode.dateTime,
                  timeLabel: 'Ends',
                  onDateTimeChanged: (date) {
                    _finalCita = date; //Asignamos la fecha de fin a la cita
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                ElevatedButton(
                  onPressed: () => showDialog<String>( //Segundo Pop-up para la eleccion de colores
                      context: this.context,
                      builder: (BuildContext context) => AlertDialog(
                        content:
                        ColorPicker(
                          // Use the screenPickerColor as start and active color.
                          color: colorElegido,
                          // Update the screenPickerColor using the callback.
                          onColorChanged: (Color color) =>
                              setState(() => colorElegido = color),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      )
                  ),
                  child: Text("Elige el color"),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text("¿Todo el día?"),
                Checkbox(
                    value: _todoDia,
                    onChanged: (bool? value){
                      print(_todoDia);
                      setState(() {
                        _todoDia = value!; //Si se selecciono o quito todo el dia asignamos su valor contrario
                      });
                    })
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => agendarCita(context, ColorTools.colorCode(colorElegido), _controladorTextoCita.text, _incioCita, _finalCita),
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
