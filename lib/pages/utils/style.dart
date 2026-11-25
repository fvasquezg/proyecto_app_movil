import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

const Color kAzul = Color(0xFF005E90);
const Color kVerde = Color(0xFF2E7D32);
const Color kGris = Color(0xFF757575);
const Color kPerdido = Color(0xFFC62828);
const Color kEncontrado = Color(0xFF00897B);

//según el tipi de publicación
Color colorTipo(String tipo) {
  return tipo == 'Perdido' ? kPerdido : kEncontrado;
}

//según categoría
IconData iconoCategoria(String categoria) {
  switch (categoria) {
    case 'Electrónica':
      return MdiIcons.cellphone;
    case 'Documentos':
      return MdiIcons.fileDocument;
    case 'Ropa y accesorios':
      return MdiIcons.tshirtCrew;
    case 'Llaves':
      return MdiIcons.key;
    case 'Útiles':
      return MdiIcons.pencil;
    default:
      return MdiIcons.packageVariant;
  }
}
