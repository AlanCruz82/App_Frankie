import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Secundaria extends StatelessWidget {

  //Coordenadas del usuario que se van a obtener
  String _corX = "";
  String _corY = "";

  //Controlador del TextField para maniupular su texto
  TextEditingController _cajaTexto = TextEditingController();

  //Permisos de ubicación (De la documentación de pub.dev)
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  //Configuración de precisión de ubicación
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  //Método para obtener la ubicacción
  void obtenerUbicacion() async {
    //Obtener la ubicación con la precisión configurada
    Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

    //Asignamos el valor de las coordenadas a su variable usando toString para obtener el estado en cadena
    _corX = position.longitude.toString();
    _corY = position.latitude.toString();

    //Cambio de la cadena de texto del textfield por el valor de las coordenadas usando toString para obtener el estado en cadena
    _cajaTexto.text = "Latitud : " + _corY + " Longitud : " + _corX;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geolocalizador"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                  hintText: "Tus coodernadas"
              ),
              controller: _cajaTexto,
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            ElevatedButton(
                onPressed: obtenerUbicacion,
                child: Text("Obtener mis coordenadas"))
          ],
        ),
      ),
    );
  }
}