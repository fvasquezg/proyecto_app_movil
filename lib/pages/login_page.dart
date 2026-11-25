import 'package:flutter/material.dart';
import 'package:proyecto_moviles/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  String msjError = "";
  bool hayError = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final resul = await AuthService().login();
            if (resul == null && mounted) {
              hayError = true;
              msjError = "No se puedo iniciar sesión.";
              setState(() {});
            }
          },
          child: Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Text(
              'Inicia Sesión con Google',
              style: TextStyle(fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}
