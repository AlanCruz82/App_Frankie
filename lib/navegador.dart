import 'package:flutter/material.dart';
import 'package:frankie/pantallas/cuarta.dart';
import 'package:frankie/pantallas/wipersonal.dart';
import 'pantallas/principal.dart';  // Asegúrate de que FirstScreen esté correctamente definida
import 'pantallas/segunda.dart';    // Asegúrate de que SecondScreen esté correctamente definida
import 'pantallas/calc.dart';       // Asegúrate de que CalcScreen esté correctamente importada
import 'pantallas/tercera.dart';
import 'pantallas/ingresar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

//Lista de widgets que almacenan nuestras pantallas utilizadas
class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 4;  // Indice inicial
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    //Inicalizamos el estado de cada pantalla, pasandole la funcion para cambiar de pantalla a la pantalla del login
    _screens = [
      Principal(),
      Secundaria(),
      Tercera(),
      Cuarta(),
      Ingresar(OnPantallaBienvenida: _ingresoExitoso),
      Wipersonal(),
      Calculadora(),
    ];
  }

  //Método para regresar a la pantalla de bienvenida si el usuario se logeo exitosamente
  void _ingresoExitoso(){
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],  // Cargar la pantalla correspondiente al indice
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, //Propiedad para evitar que se quede en blanco después de 3 pantallas/items
        currentIndex: _currentIndex,  // El índice actual para cambiar la pantalla
        onTap: (index) { // cuando el usuario toca un icono cambiamos el indice
          setState(() { // actualizamos el estado para mostrar la pantalla
            _currentIndex = index;  // Cambiar el índice al hacer clic en un ítem
          });
        },
        items: [ // botones de la app con los cuales vamos a navegar entre pantallas
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Principal"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Geolocalizador"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Agenda"),
          BottomNavigationBarItem(icon: Icon(Icons.timelapse_outlined), label: "Contador"),
          BottomNavigationBarItem(icon: Icon(Icons.login), label: "Login"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "MapAragón"),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: "Calculadora"),
        ],
      ),
    );
  }
}
