import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  bool _showText = true;
  double _iconSize = 50.0;

  //Nombre del usuario
  String? _nombreUsuario = "";

  //Inicamos el estado de la pantalla con el nombre del usuario
  @override
  void initState() {
    super.initState();
    obtenerNombreUsuario();
  }

  //Obtenemos el nombre del usuario
  Future<void> obtenerNombreUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreUsuario = prefs.getString('nombre');
    });
  }
  void _onButtonPressed() {
    setState(() {
      if (_showText) {
        _showText = false;
      } else {
        _iconSize += 10;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pantalla de bienvenida"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_showText) Text("Presiona el botón"),
            if (!_showText) Icon(Icons.account_balance_wallet_sharp, size: _iconSize, color: Colors.blue),
            Text("Bienvenido " + _nombreUsuario.toString()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onButtonPressed,
        child: Icon(Icons.access_time),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
