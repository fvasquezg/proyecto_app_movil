import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_moviles/pages/utils/style.dart';
import 'package:proyecto_moviles/services/objetos_service.dart';

class DetallesObjeto extends StatelessWidget {
  const DetallesObjeto({super.key, required this.objeto});
  final QueryDocumentSnapshot objeto;

  Widget _fila(IconData icono, String texto) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icono, size: 20, color: kGris),
          SizedBox(width: 8),
          Expanded(child: Text(texto)),
        ],
      ),
    );
  }

  Widget _etiqueta(String texto, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        texto,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  void confirmarBorrado(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Borrar publicación', style: TextStyle(fontSize: 18)),
        content: Text('¿Seguro que desea borrar ${objeto['titulo']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              ObjetosService().borrarPublicacion(objeto.id);
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: kPerdido),
            child: Text('Borrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool esAutor = objeto['autorUid'] == FirebaseAuth.instance.currentUser!.uid;
    bool vigente = objeto['estado'] == 'Vigente';
    String tipo = objeto['tipo'];
    String categoria = objeto['categoria'];
    DateTime fecha = (objeto['fecha'] as Timestamp).toDate();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAzul,
        foregroundColor: Colors.white,
        title: Text(objeto['titulo'], overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.memory(
              (objeto['foto'] as Blob).bytes,
              width: double.infinity,
              height: 260,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    objeto['titulo'],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      _etiqueta(tipo, colorTipo(tipo)),
                      SizedBox(width: 8),
                      _etiqueta(objeto['estado'], vigente ? kVerde : kGris),
                    ],
                  ),
                  SizedBox(height: 16),
                  _fila(iconoCategoria(categoria), categoria),
                  _fila(MdiIcons.mapMarker, objeto['lugar']),
                  _fila(
                    MdiIcons.calendar,
                    DateFormat('dd/MM/yyyy HH:mm').format(fecha),
                  ),
                  _fila(MdiIcons.account, objeto['autorNombre']),
                  SizedBox(height: 8),
                  Text(
                    'Descripción',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(objeto['descripcion']),
                  SizedBox(height: 24),
                  esAutor
                      ? Column(
                          children: [
                            if (vigente)
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: () {
                                    ObjetosService().marcarDevuelto(objeto.id);
                                    Navigator.pop(context);
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: kVerde,
                                  ),
                                  child: Text('Marcar como devuelto'),
                                ),
                              ),
                            if (vigente) SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: () => confirmarBorrado(context),
                                style: FilledButton.styleFrom(
                                  backgroundColor: kPerdido,
                                ),
                                child: Text('Borrar'),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(height: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
