import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Heredamos de un Stateful para poder modificar los colores
class Tercera extends StatefulWidget {
  @override
  TerceraPantallaState createState() => TerceraPantallaState();
}

//Herencia del Stateful
class TerceraPantallaState extends State<Tercera> {

  //Iniciamos el estado del calendario con las citas previamente agendadas
  @override
  void initState(){
    super.initState();
    obtenerCitas();
  }

  final db = FirebaseFirestore.instance;
  Color _color = Colors.blue; //Color por defecto
  int _colorElegido = 0;
  TextEditingController _nombreCita = TextEditingController();
  DateTime? _incioCita = DateTime.now();
  DateTime? _finalCita = DateTime.now();
  bool? _todoDia = false;
  List<Meeting> _citas = [];

  //Metodo para guardar los datos de la cita en firebase con los valores del usuario
  void agendarCita() async{
    Map<String,dynamic> propiedadesCita = {
      'fechaInicio' : _incioCita,
      'fechaFin' : _finalCita,
      'color' : _colorElegido,
      'todoDia' : _todoDia
    };
    //Guardamos la cita en la coleccion 'Eventos' con el nombre de la cita como nombre del documento
    await db.collection("Eventos").doc(_nombreCita.text).set(propiedadesCita);
  }

  //Metodo para obtener las citas previamente agendadas y almacenadas en firebase
  void obtenerCitas() async{
    //Obtenemos las citas almacenadas en nuestra coleccion 'Eventos' en firebase
    QuerySnapshot eventos = await db.collection('Eventos').get();
    for(DocumentSnapshot cita in eventos.docs){
      //Vamos recorriendo cada cita/doc y construyendo la cita con sus detalles para despues pasarselos a getDataSource
      Map<String,dynamic> propiedadesCita = cita.data() as Map<String,dynamic>;
      String tituloCita = cita.id;
      DateTime inicioCita = (propiedadesCita['fechaInicio'] as Timestamp).toDate();
      DateTime finCita = (propiedadesCita['fechaFin'] as Timestamp).toDate();
      Color colorCita = Color(propiedadesCita['color']);
      bool todoElDia = propiedadesCita['todoDia'];

      //Vamos generando una nueva instancia de tipo Meeting para cada cita previamente guardada en firebase
      _citas.add(new Meeting(tituloCita, inicioCita, finCita, colorCita, todoElDia));
    }
    //Refrescamos el estado de la pantalla para mostrar las citas agendadas
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SfCalendar(
          view: CalendarView.month,
          dataSource: MeetingDataSource(_getDataSource(_citas)), //Le mandamos las citas agendadas que obtuvimos de firebase para mostrarlas en el calendario
            monthViewSettings: MonthViewSettings(showAgenda: true), //Ocupamos la vista tipo agenda para ver las citas agendadas
                                                                    //Si no solo se ven puntitos de color debajo de la fecha
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
                  controller: _nombreCita,
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
                  initialDateTime: DateTime.now(),
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
                  initialDateTime: DateTime.now(),
                  currentDateTime: DateTime.now(),
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
                onPressed: (){
                  agendarCita();
                  //Limpiamos los campos de las propiedades de la cita
                  _nombreCita.text = "";
                  _incioCita = DateTime.now();
                  _finalCita = DateTime.now();
                  _colorElegido = 0;
                  _todoDia = false;

                  //Cerramos el alertDialog donde mostramos los detalles de la cita
                  Navigator.pop(context, 'OK');
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Para poder reflejar las citas dentro del SfCalendario ocupamos su propiedad DataSource, la cual debe
//recibir la colección de citas con sus propiedades/detalles dadas por el usuario
// [https://pub.dev/packages/syncfusion_flutter_calendar#add-data-source]
List<Meeting> _getDataSource(List<Meeting> citasAgendadas) {
  return citasAgendadas;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}