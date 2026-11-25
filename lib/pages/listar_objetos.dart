import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:proyecto_moviles/pages/detalles_objeto.dart';
import 'package:proyecto_moviles/utils/style.dart';

class ListarObjetos extends StatelessWidget {
  const ListarObjetos({super.key, required this.stream});
  final Stream<QuerySnapshot> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        var objetos = snapshot.data!.docs;
        if (objetos.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(MdiIcons.packageVariant, size: 64, color: kGris),
                SizedBox(height: 8),
                Text('No hay objetos', style: TextStyle(color: kGris)),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 8),
          separatorBuilder: (context, index) => SizedBox(height: 4),
          itemCount: objetos.length,
          itemBuilder: (context, index) {
            var objeto = objetos[index];
            bool devuelto = objeto['estado'] == 'Devuelto';
            String tipo = objeto['tipo'];
            String categoria = objeto['categoria'];
            return Card(
              color: devuelto ? Colors.grey.shade200 : Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: ListTile(
                leading: Image.memory(
                  (objeto['foto'] as Blob).bytes,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  objeto['titulo'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: devuelto ? kGris : Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tipo,
                      style: TextStyle(
                        color: devuelto ? kGris : colorTipo(tipo),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(iconoCategoria(categoria), size: 16, color: kGris),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            categoria,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Text(
                  objeto['estado'],
                  style: TextStyle(
                    color: devuelto ? kGris : kVerde,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetallesObjeto(objeto: objeto),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
