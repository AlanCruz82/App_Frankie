import 'package:flutter/material.dart';
import 'package:frankie/pantallas/principal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frankie/navegador.dart';

class Ingresar extends StatelessWidget {
  //Texto del textfield
  TextEditingController _nombre = TextEditingController();
  final Function OnPantallaBienvenida;
  //Obligamos a que la instancia de esta pantalla necesite una función que nos permita cambiar a la pantalla principal (desde navegador.dart)
  Ingresar({required this.OnPantallaBienvenida, Key? key}) : super(key: key);

  //Método para guardar el nombre del usuario
  Future<void> guardarNombre(String nombre) async{
    final prefs = await SharedPreferences.getInstance();

    //Si el nombre no es una cadena vacía
    if(nombre.isNotEmpty){
      //Almacenamos el nombre del usuario con clave 'nombre' y cambiamos a la pantalla de bienvenida
      await prefs.setString('nombre', nombre);
      OnPantallaBienvenida();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login básico"),
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
                      hintText: "Ingresa tu nombre",
                    ),
                    controller: _nombre,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  ElevatedButton(onPressed: (){
                    guardarNombre(_nombre.text);
                  },
                      child: Text("Ingresar"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}