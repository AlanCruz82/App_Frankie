import 'package:flutter/material.dart';

class ImagenInteractiva extends StatelessWidget {
  const ImagenInteractiva({super.key});

  // todas las tiendas
  // ya no se usa firebase como lo haciamos en el proyecto
  final Map<String, Offset> _posiciones = const { // donde se va a dibujar cada iconbutton
    'tienda_01': Offset(0.55, 0.47),
    'tienda_02': Offset(0.55, 0.47), // frente al a3
    'tienda_03': Offset(0.59, 0.41),
    'tienda_04': Offset(0.59, 0.41),
    'tienda_05': Offset(0.59, 0.41),
    'tienda_06': Offset(0.59, 0.41), // atras del a2
    'tienda_07': Offset(0.46, 0.36),
    'tienda_08': Offset(0.46, 0.36), // entre el a4 y a5
    'tienda_09': Offset(0.4, 0.31),
    'tienda_10': Offset(0.4, 0.31), // al costado del l3
    'tienda_11': Offset(0.5, 0.23),
    'tienda_12': Offset(0.5, 0.23),
    'tienda_13': Offset(0.5, 0.23),
    'tienda_14': Offset(0.5, 0.23), // al frente del a5
    'tienda_15': Offset(0.56, 0.26),
    'tienda_16': Offset(0.56, 0.26), // enfrente del a12 y a6
    'tienda_17': Offset(0.214, 0.247),
    'tienda_18': Offset(0.214, 0.247), // al frente del gimnasio
    'tienda_19': Offset(0.494, 0.32), // colectivo en el a6
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container( // contenedor para hacer un borde alrededor del interactive viewer
          decoration: BoxDecoration( // porque la imagen es una png y no se veia bien
            border: Border.all(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(50), // deslizamiento fuera de la imagen en pixeles
            minScale: 0.85, // minimos y maximos del zoom a la img
            maxScale: 4.0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // AGRUPAR TIENDAS
                // muchas tiendas están muy juntas y se veía muy mal el mapa con tantos iconos
                // entonces decidí agrupar las que tengan las mismas coordenadas
                // y mostrar un menú para seleccionar la que quisieras
                final Map<Offset, List<String>> agrupadas = {};
                _posiciones.forEach((id, offset) {
                  agrupadas.putIfAbsent(offset, () => []).add(id);
                });

                // widget para poder poner los iconbuttons encima de la imagen
                // https://www.dhiwise.com/post/flutter-stack-your-ultimate-guide-to-overlapping-widgets
                return Stack(
                  children: [
                    Image.asset( // traer la imagen
                      'lib/recursos/mapaAragon.png',
                      fit: BoxFit.contain,
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                    ...agrupadas.entries.map((entry) {
                      final left = entry.key.dx * constraints.maxWidth;
                      final top = entry.key.dy * constraints.maxHeight;
                      return Positioned(
                        left: left,
                        top: top,
                        child: IconButton(
                          icon: Icon(
                            // si hay más de 1 icono en una posición se usa el icono 1 y si solo hay 1 se usa el icono 2
                            // esto solo sirve en el caso del colectivo :3
                            entry.value.length > 1 ? Icons.storefront : Icons.store,
                            color: Colors.redAccent,
                            size: 24,
                          ),
                          onPressed: () { // trabajamos con las coordenadas agrupadas
                            for (var id in entry.value) { // recorrer las tiendas que estan agrupadas
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(// widget para el mensaje que se muestra
                                  content: Text('Icono $id tocado'),
                                  duration: const Duration(seconds: 1), // duracion
                                ),
                              );
                            }

                          },
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
