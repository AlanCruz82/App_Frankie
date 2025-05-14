import 'package:flutter/material.dart';

class Calculadora extends StatefulWidget { // usamos un stateful widget porque los componentes d ela interfaz cambian
  @override
  _CalculadoraState createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String _entrada = ""; // variable para almacenar la entrada del usuario
  String _resultado = "0"; // variable para guardar el resultado de la operacion

  void _botonPresionado(String valor) {
    setState(() {
      if (valor == "=") {
        try {
          _resultado = _evaluarExpresion(_entrada).toString();
        } catch (e) {
          _resultado = "Error";
        }
      } else if (valor == "C") {
        _entrada = "";
        _resultado = "0";
      } else {
        _entrada += valor;
      }
    });
  }

  // Método para evaluar la expresión
  double _evaluarExpresion(String expresion) {
    // Primero, reemplazamos las operaciones de división, multiplicación, suma y resta
    expresion = expresion.replaceAll('x', '*').replaceAll(
        '÷', '/'); // Usar los símbolos estándar

    // Ahora, evaluamos la expresión de izquierda a derecha (simplificación)
    double resultado = 0;
    List<String> elementos = _splitExpresion(expresion);

    // Operaciones básicas de suma y resta
    resultado = double.parse(elementos[0]);

    for (int i = 1; i < elementos.length; i += 2) {
      String operador = elementos[i];
      double numero = double.parse(elementos[i + 1]);

      if (operador == '+') {
        resultado += numero;
      } else if (operador == '-') {
        resultado -= numero;
      } else if (operador == '*') {
        resultado *= numero;
      } else if (operador == '/') {
        resultado /= numero;
      }
    }

    return resultado;
  }

  // Método para dividir la expresión en elementos (números y operadores)
  List<String> _splitExpresion(String expresion) {
    List<String> elementos = [];
    String numeroActual = "";

    for (int i = 0; i < expresion.length; i++) {
      String char = expresion[i];

      if (char == '+' || char == '-' || char == '*' || char == '/') {
        if (numeroActual.isNotEmpty) {
          elementos.add(numeroActual);
        }
        elementos.add(char);
        numeroActual = "";
      } else {
        numeroActual += char;
      }
    }

    if (numeroActual.isNotEmpty) {
      elementos.add(numeroActual);
    }

    return elementos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 0, // propiedad para ver cuanto espacio ocupa el widget
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_entrada, style: TextStyle(fontSize: 24)),
                  Text(_resultado,
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4, // para el espacio que ocupan los botones
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                itemCount: botones.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () => _botonPresionado(botones[index]),
                    child: Text(
                      botones[index],
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(0),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<String> botones = [
    "7", "8", "9", "/",
    "4", "5", "6", "*",
    "1", "2", "3", "-",
    "0", "C", "=", "+",
  ];
}