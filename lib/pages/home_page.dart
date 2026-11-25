import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:proyecto_moviles/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF005E90),
        leading: Icon(MdiIcons.accountBadge, size: 26, color: Colors.white),
        title: Text(
          user?.displayName ?? user?.email ?? "Cargando datos...",
          style: TextStyle(color: Colors.white, fontSize: 20),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().logout();
            },
            icon: Icon(MdiIcons.logout, size: 24, color: Colors.white),
            tooltip: "Cerrar Sesión",
          ),
        ],
      ),
      body: Center(child: Text('FYP')),
    );
  }
}
