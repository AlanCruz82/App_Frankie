import 'package:flutter/material.dart';
import 'package:frankie/widget/imagenInteractiva.dart';

class Wipersonal extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa de las tiendas en la FES Aragón"),
        backgroundColor: Color.fromARGB(255, 234, 210, 250),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ImagenInteractiva(), // widget personalizado del mapa
      ),
    );
  }
}
