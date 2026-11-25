import 'package:cloud_firestore/cloud_firestore.dart';

class ObjetosService {
  //obtener objetos
  Stream<QuerySnapshot> categorias() {
    return FirebaseFirestore.instance.collection('categorias').snapshots();
  }
  //agregar un objeto perdido

  //borrar objeto publicado
  Future<void> borrarPublicacion(String id) {
    return FirebaseFirestore.instance.collection('categoria').doc(id).delete();
  }
  //editar objeto
}
