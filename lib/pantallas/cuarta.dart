import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cuarta extends StatefulWidget {
  @override
  CuartaPantallaState createState() => CuartaPantallaState();
}

//Herencia del Stateful
class CuartaPantallaState extends State<Cuarta>{
  TextEditingController _contador = TextEditingController();
  final db = FirebaseFirestore.instance;
  String _ultimoContador = "";

  //Generamos un número al azar utilizando Ramdon
  void numeroAleatorio() async{
    Random random = new Random();
    int numeroAzar = random.nextInt(50) + 1;
    _contador.text = "Número generado : " + numeroAzar.toString();

    //Establecemos el valor del campo numero (firebase) como el valor del numeroAzar generado
    await db.collection("Contadores").doc("contador").set({
      'numero' : numeroAzar,
    });

    //Obtenemos el ultimo valor dado al número en firebase y lo pintamos en el Text
    DocumentSnapshot contador = await db.collection("Contadores").doc("contador").get();
    Map<String,dynamic> numero = contador.data() as Map<String,dynamic>;
    setState(() {
      _ultimoContador = "Ultimo número sincronizado : " + numero['numero'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contador"),
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
                      hintText: "Contador sincronizado con la nube",
                    ),
                    controller: _contador,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Text(_ultimoContador),
                  ElevatedButton(onPressed: (){
                    numeroAleatorio();
                  },
                      child: Text("Genera un número"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
