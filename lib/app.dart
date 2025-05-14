import 'package:flutter/material.dart';
import 'navegador.dart';  // Asegúrate de que esta importación sea correcta

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( // envoltorio
      debugShowCheckedModeBanner: false, // la primera pantalla en mostrarse es nuestra mainscreen que contiene el bottomnavbar
      home: MainScreen(),  // Esto debería hacer referencia a MainScreen desde 'navegador.dart'
    );
  }
}
