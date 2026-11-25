import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_moviles/pages/home_page.dart';
import 'package:proyecto_moviles/pages/login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      //cada vez que hay un login o logout la app se reconstruiye desde acá porque cambia qué pantalla se ve
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //envuelto en un scaffold porque a veces cargaba con un fondo negro
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        //si hay info de algun user los llevará a la pag de inicio
        if (snapshot.hasData) {
          return HomePage();
        }
        //si no hay data del user seguirá en la pág de log in
        return LoginPage();
      },
    );
  }
}
