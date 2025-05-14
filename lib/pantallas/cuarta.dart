import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

//Herencia del Stateful
class Cuarta extends StatelessWidget {
  TextEditingController _contador = TextEditingController();
  final db = FirebaseFirestore.instance;

  //Generamos un número al azar utilizando Ramdon
  void numeroAleatorio() async{
    Random random = new Random();
    int numeroAzar = random.nextInt(50) + 1;
    _contador.text = "Número generado : " + numeroAzar.toString();

    //Establecemos el valor del campo numero (firebase) como el valor del numeroAzar generado
    await db.collection("Contadores").doc("contador").set({
      'numero' : numeroAzar,
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
              width: 400,
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
