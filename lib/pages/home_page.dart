import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:proyecto_moviles/pages/agregar_objeto.dart';
import 'package:proyecto_moviles/pages/listar_objetos.dart';
import 'package:proyecto_moviles/pages/utils/style.dart';
import 'package:proyecto_moviles/services/auth_service.dart';
import 'package:proyecto_moviles/services/objetos_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;
  final Stream<QuerySnapshot> streamInicio = ObjetosService().objetos();
  final Stream<QuerySnapshot> streamMisObjetos = ObjetosService().misObjetos();

  @override
  void initState() {
    super.initState();
    AuthService().currentUser().then((currentU) {
      if (!mounted) return;
      setState(() {
        user = currentU;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kAzul,
          leading: Icon(MdiIcons.accountBadge, size: 26, color: Colors.white),
          title: Text(
            user?.displayName ?? user?.email ?? 'Cargando datos...',
            style: TextStyle(color: Colors.white, fontSize: 20),
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await AuthService().logout();
              },
              icon: Icon(MdiIcons.logout, size: 24, color: Colors.white),
              tooltip: 'Cerrar Sesión',
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Inicio'),
              Tab(text: 'Mis objetos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListarObjetos(stream: streamInicio),
            ListarObjetos(stream: streamMisObjetos),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kAzul,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AgregarObjeto()),
            );
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
