import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/login_form.dart';
import '../widgets/register_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/FondoLogin.webp"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: isLogin ? 0.0 : 1.0),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeInOutCubic,
              builder: (context, value, child) {
                final angle = value * pi; // de 0 a 180 grados

                // 🔹 Detectamos qué cara mostrar
                final isFront = angle <= (pi / 2);

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(angle),
                  child: Container(
                    width: MediaQuery.of(context).size.width < 400
                        ? MediaQuery.of(context).size.width * 0.9
                        : 350,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          // 🔹 Solo un formulario se muestra a la vez
                          child: isFront
                              ? LoginForm(
                            onRegisterTap: () =>
                                setState(() => isLogin = false),
                          )
                              : Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(pi),
                            child: RegisterForm(
                              onLoginTap: () =>
                                  setState(() => isLogin = true),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
