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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade500,
        leading: Icon(
          MdiIcons.accountBadge,
          size: 26,
          color: Colors.white,
        ), //cambiar
        title: Text(
          user?.email ?? "Cargando datos...",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().logout();
            },
            icon: Icon(MdiIcons.logout, size: 24, color: Colors.white),
          ),
        ],
      ),
      body: Center(child: Text('FYP')),
    );
  }
}
