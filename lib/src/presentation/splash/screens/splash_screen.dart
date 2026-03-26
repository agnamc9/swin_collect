import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tax_collect/src/data/data.dart';
import 'package:tax_collect/src/presentation/home/home.dart';
import 'package:tax_collect/src/presentation/presentation.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String? appVersion;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAppVersion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Center(child: CircularProgressIndicator())),
            Text(
              appVersion != null ? 'v$appVersion' : '',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _getAppVersion() async {
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        appVersion = packageInfo.version;
      });
      runSplash();
    });
  }

  void runSplash() {
    Future.delayed(const Duration(seconds: 3), () {
      bool hasSession = ref.read(userRepositoryProvider).getUser() != null;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => hasSession ? HomeScreen() : SigninScreen(),
        ),
      );
    });
  }
}
