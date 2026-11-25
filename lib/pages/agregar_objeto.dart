import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_moviles/pages/utils/style.dart';
import 'package:proyecto_moviles/services/objetos_service.dart';

class AgregarObjeto extends StatefulWidget {
  const AgregarObjeto({super.key});

  @override
  State<AgregarObjeto> createState() => _AgregarObjetoState();
}

class _AgregarObjetoState extends State<AgregarObjeto> {
  final formKey = GlobalKey<FormState>();
  final tituloCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();
  final lugarCtrl = TextEditingController();
  String? tipoSeleccionado;
  String? categoriaSeleccionada;
  DateTime fechaSeleccionada = DateTime.now();
  Uint8List? fotoBytes;
  String mensajeErrorFoto = '';
  bool hayErrorFoto = false;
  bool guardando = false;
  final tipos = ['Perdido', 'Encontrado'];

  @override
  void dispose() {
    tituloCtrl.dispose();
    descripcionCtrl.dispose();
    lugarCtrl.dispose();
    super.dispose();
  }

  Future<void> elegirFoto(ImageSource origen) async {
    final xfile = await ImagePicker().pickImage(
      source: origen,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 70,
    );
    if (xfile == null) return;
    final bytes = await xfile.readAsBytes();
    if (!mounted) return;
    if (bytes.length > 900 * 1024) {
      setState(() {
        hayErrorFoto = true;
        mensajeErrorFoto = 'La foto pesa demasiado';
      });
      return;
    }
    setState(() {
      fotoBytes = bytes;
      hayErrorFoto = false;
    });
  }

  void elegirFecha() {
    showDatePicker(
      context: context,
      initialDate: fechaSeleccionada,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    ).then((fecha) {
      if (fecha == null || !mounted) return;
      showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(fechaSeleccionada),
      ).then((hora) {
        if (hora == null || !mounted) return;
        setState(() {
          fechaSeleccionada = DateTime(
            fecha.year,
            fecha.month,
            fecha.day,
            hora.hour,
            hora.minute,
          );
        });
      });
    });
  }

  Future<void> guardar() async {
    if (!formKey.currentState!.validate()) return;
    if (fotoBytes == null) {
      setState(() {
        hayErrorFoto = true;
        mensajeErrorFoto = 'La foto es obligatoria';
      });
      return;
    }
    if (guardando) return;
    guardando = true;
    try {
      await ObjetosService().agregarObjeto(
        titulo: tituloCtrl.text.trim(),
        descripcion: descripcionCtrl.text.trim(),
        tipo: tipoSeleccionado!,
        categoria: categoriaSeleccionada!,
        lugar: lugarCtrl.text.trim(),
        fecha: fechaSeleccionada,
        fotoBytes: fotoBytes!,
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (ex) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No se pudo publicar')));
    } finally {
      guardando = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAzul,
        foregroundColor: Colors.white,
        title: Text('Publicar objeto'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: tituloCtrl,
                  decoration: InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Indique el título';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: descripcionCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Indique la descripción';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Tipo'),
                  isExpanded: true,
                  items: tipos
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (valor) {
                    tipoSeleccionado = valor;
                  },
                  validator: (valor) {
                    if (valor == null) {
                      return 'Seleccione el tipo';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                StreamBuilder(
                  stream: ObjetosService().categorias(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return Text('Cargando categorías...');
                    }
                    var categorias = snapshot.data!.docs;
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Categoría'),
                      isExpanded: true,
                      items: categorias
                          .map(
                            (c) => DropdownMenuItem<String>(
                              value: c['nombre'],
                              child: Text(c['nombre']),
                            ),
                          )
                          .toList(),
                      onChanged: (valor) {
                        categoriaSeleccionada = valor;
                      },
                      validator: (valor) {
                        if (valor == null) {
                          return 'Seleccione la categoría';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: lugarCtrl,
                  decoration: InputDecoration(labelText: 'Lugar'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Indique el lugar';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(MdiIcons.calendar, color: kGris),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        DateFormat('dd/MM/yyyy HH:mm')
                            .format(fechaSeleccionada),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      onPressed: elegirFecha,
                      icon: Icon(MdiIcons.calendar, color: kAzul),
                      tooltip: 'Elegir fecha y hora',
                    ),
                  ],
                ),
                SizedBox(height: 12),
                fotoBytes != null
                    ? Image.memory(
                        fotoBytes!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: kGris),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Icon(MdiIcons.image, size: 64, color: kGris),
                        ),
                      ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => elegirFoto(ImageSource.camera),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(MdiIcons.camera),
                            SizedBox(width: 8),
                            Text('Cámara'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => elegirFoto(ImageSource.gallery),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(MdiIcons.image),
                            SizedBox(width: 8),
                            Text('Galería'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                hayErrorFoto
                    ? Container(
                        height: 40,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.red.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(MdiIcons.alert, color: Colors.red),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                mensajeErrorFoto,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(height: 40),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: guardar,
                    style: FilledButton.styleFrom(backgroundColor: kAzul),
                    child: Text('Publicar'),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
