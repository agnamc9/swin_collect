import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tax_collect/src/presentation/presentation.dart';
import 'package:tax_collect/src/widgets/dialogs.dart';

import '../../home/home.dart';

class SigninScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends ConsumerState<SigninScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late SigninController _signinController;

  final _formKey = GlobalKey<FormState>();

  String? appVersion;
  @override
  void initState() {
    _signinController = ref.read(signinControllerProvider);
    if (kDebugMode) {
      _usernameController.text = "agent1";
      _passwordController.text = "password1";
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAppVersion();
    });
  }

  void _getAppVersion() async {
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        appVersion = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Veuillez renseigner vos identifiants pour vous connecter',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      Gap(16),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          text: "Identifiant",
                          children: [
                            TextSpan(
                              text: " *",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      Gap(8),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "L'identifiant est requis";
                          }
                          return null;
                        },
                      ),
                      Gap(16),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          text: "Mot de passe",
                          children: [
                            TextSpan(
                              text: " *",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      Gap(16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Le mot de passe";
                          }
                          return null;
                        },
                      ),
                      Gap(16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _submit();
                          }
                        },
                        child: Text("Se connecter"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Gap(4),
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

  void _submit() async {
    showLoadingDialog(context);
    var response = await _signinController.signin(
      _usernameController.text,
      _passwordController.text,
    );
    Navigator.pop(context);
    if (!response.success!) {
      showInfoDialog(context, message: response.message ?? '');
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (route) => false,
    );
  }
}
