import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'shared/widgets/neu_container.dart';
import 'shared/widgets/neu_text_field.dart';
import 'shared/widgets/neu_button.dart';
import 'core/router/app_router.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MubtadiaatApp(),
    ),
  );
}

class MubtadiaatApp extends StatelessWidget {
  const MubtadiaatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Mubtadi'at App",
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 6)),
                    const BoxShadow(color: Colors.white, blurRadius: 10, offset: Offset(-4, -4)),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Image.asset('assets/images/logo.png', fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.school_rounded, size: 40, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 14),
              Text("PP. Hidayatul Mubtadi'at",
                style: TextStyle(fontSize: isDesktop ? 20 : 17, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text('Lirboyo - Kediri', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12)),
              const SizedBox(height: 28),

              // Login Card
              Container(
                width: isDesktop ? 380 : double.infinity,
                constraints: const BoxConstraints(maxWidth: 400),
                child: NeuContainer(
                  padding: const EdgeInsets.all(20),
                  borderRadius: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Masuk ke Akun Anda', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                      const SizedBox(height: 18),
                      const NeuTextField(
                        label: 'Username / Email',
                        hint: 'Masukkan username',
                        prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
                      ),
                      const SizedBox(height: 14),
                      const NeuTextField(
                        label: 'Password',
                        hint: 'Masukkan password',
                        obscureText: true,
                        prefixIcon: Icon(Icons.lock_outline_rounded, size: 18),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: NeuButton(
                          color: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          borderRadius: 10,
                          onPressed: () {
                            context.go('/dashboard');
                          },
                          child: const Center(
                            child: Text('LOGIN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 1)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

