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
  Color _color = Colors.blue; //Color por defecto
  int _colorElegido = 0;
  TextEditingController _controladorTextoCita = TextEditingController();
  DateTime _incioCita = DateTime.now();
  DateTime _finalCita = DateTime.now();
  bool? _todoDia = false;

  void agendarCita(context, colorSeleccionado, encabezadoCita, fechaInicio, fechaFin, todoElDia){
    print("Titulo cita " + encabezadoCita);
    print("Inicio cita " + fechaInicio.toString());
    print("Final cita " + fechaFin.toString());
    print("Color " + colorSeleccionado.toString());
    print("Todo el día " + todoElDia.toString());
    Navigator.pop(context, 'OK');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SfCalendar(
          view: CalendarView.week,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Agenda tu cita'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
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
                  timeLabel: 'Inicio',
                  onDateTimeChanged: (startdate) {
                    _incioCita = startdate; //Asignamos la fecha de inicio a la cita
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
                  timeLabel: 'Fin',
                  onDateTimeChanged: (enddate) {
                    _finalCita = enddate; //Asignamos la fecha de fin a la cita
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
                          //Color por defecto azul
                          color: _color,
                          //Cuando cambie el color, dejamos ese color y almacenamos su valor en 32bits
                          onColorChanged: (Color color){
                            setState(() {
                              _color = color;
                              _colorElegido = _color.value32bit;
                            });
                          }
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
                //Con StateBuilder podemos generar un propio StateFul para el checkbox cuando cambia de valor
                StatefulBuilder(builder: (BuildContext context, StateSetter setDialogState){
                  return Column(
                   children: [
                     Checkbox(
                       value: _todoDia,
                       onChanged: (bool? value) {
                         setDialogState(() {
                           _todoDia = value ?? false;
                         });
                       },
                     ),
                   ],
                  );
                })
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => agendarCita(context, _colorElegido,
                    _controladorTextoCita.text, _incioCita, _finalCita, _todoDia),
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}