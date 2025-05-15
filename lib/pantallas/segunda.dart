import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Secundaria extends StatelessWidget {

  //Coordenadas del usuario que se van a obtener
  String _corX = "";
  String _corY = "";

  //Controlador del TextField para maniupular su texto
  TextEditingController _cajaTexto = TextEditingController();

  //Permisos de ubicación y obtencion de las coordenadas (De la documentación de pub.dev)
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
            SizedBox(
              width: 350,
              child: Column(
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
                      onPressed: (){
                        _determinePosition().then((coordenadas){ //Obtenemos y pintamos sus coordenadas (usando el estado en string del objeto)
                          _cajaTexto.text = "Latitud : " + coordenadas.latitude.toString() + " Longitud : " + coordenadas.longitude.toString();
                        });
                      },
                      child: Text("Obtener mis coordenadas"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}