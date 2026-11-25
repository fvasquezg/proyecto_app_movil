import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:proyecto_moviles/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  String msjError = "";
  bool hayError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFF005E90)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(flex: 2),
                Text(
                  "ReqApp",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                Image.asset('assets/img/logo_usm.png', height: 110),
                Spacer(flex: 3),
                Text(
                  "Crea una cuenta",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Inicia sesión con',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    setState(() => hayError = false);
                    final resul = await AuthService().login();
                    if (resul == null && mounted) {
                      setState(() {
                        hayError = true;
                        msjError = "No se pudo iniciar sesión";
                      });
                      await Future.delayed(Duration(seconds: 4));
                      if (mounted) {
                        setState(() => hayError = false);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(180, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Icon(MdiIcons.accountCircle),
                      Image.asset('assets/img/google-logo.png', height: 20),
                      SizedBox(width: 10),
                      Text("Google"),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                hayError
                    ? Container(
                        height: 48,
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
                                msjError,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(height: 48),
                Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
