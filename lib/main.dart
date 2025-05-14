import 'package:flutter/material.dart';
import 'package:frankie/firebase_options.dart';
import 'app.dart'; // importamos el archivo que sirve como raiz para nuestra aplicacion
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp()); // mostrar el widget de myapp como inicio de la app
}
