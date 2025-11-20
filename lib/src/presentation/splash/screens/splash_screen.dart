import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tax_collect/src/data/data.dart';
import 'package:tax_collect/src/presentation/home/home.dart';
import 'package:tax_collect/src/presentation/presentation.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      bool hasSession = ref.read(userRepositoryProvider).getUser() != null;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => hasSession ? HomeScreen() : SigninScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator(strokeWidth: 1)));
  }
}
