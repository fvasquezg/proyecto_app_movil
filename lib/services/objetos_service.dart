import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:typed_data';

class ObjetosService {
  //obtener categorias
  Stream<QuerySnapshot> categorias() {
    return FirebaseFirestore.instance.collection('categorias').snapshots();
  }

  //obtener objetos ordenados por fecha
  Stream<QuerySnapshot> objetos() {
    return FirebaseFirestore.instance
        .collection('objetos')
        .orderBy('fecha', descending: true)
        .snapshots();
  }

  //obtener los objetos de uno mismo para así poder editar o borrar objeto
  Stream<QuerySnapshot> misObjetos() {
    final userUid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('objetos')
        .orderBy('fecha', descending: true)
        .where('autorUid', isEqualTo: userUid)
        .snapshots();
  }

  //agregar un objeto perdido
  Future<void> agregarObjeto({
    //lista de campos con required porque son los datos que deben tener como MINIMO
    required String titulo,
    required String descripcion,
    required String tipo,
    required String categoria,
    required String lugar,
    required DateTime fecha,
    required Uint8List fotoBytes,
  }) {
    final user = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance.collection('objetos').add({
      'titulo': titulo,
      'descripcion': descripcion,
      'tipo': tipo,
      'categoria': categoria,
      'lugar': lugar,
      'fecha': Timestamp.fromDate(fecha),
      'foto': Blob(fotoBytes),
      'estado': "Vigente",
      'autorUid': user.uid,
      'autorNombre': user.displayName ?? "Sin nombre",
    });
  }

  //borrar objeto publicado
  Future<void> borrarPublicacion(String id) {
    return FirebaseFirestore.instance.collection('objetos').doc(id).delete();
  }

  //editar objeto marcandolo como devuelto
  Future<void> marcarDevuelto(String id) {
    return FirebaseFirestore.instance.collection('objetos').doc(id).update({
      'estado': "Devuelto",
    });
  }
}
