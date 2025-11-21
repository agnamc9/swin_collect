import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tax_collect/src/presentation/profile/controllers/controllers.dart';
import 'package:tax_collect/src/presentation/presentation.dart';
import 'package:tax_collect/src/widgets/dialogs.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileController = ref.watch(profileControllerProvider);
    final user = profileController.getUser();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.person_outline_outlined, color: Colors.grey),
          ),
          const Gap(16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildRowInfo("Nom d'utilisateur", user.username ?? ''),
                  Container(margin: const EdgeInsets.symmetric(vertical: 8), child: Divider()),
                  _buildRowInfo("Nom et prénoms", user.fullname),
                  Container(margin: const EdgeInsets.symmetric(vertical: 8), child: Divider()),
                  _buildRowInfo("Email", user.email ?? ''),
                ],
              ),
            ),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () async {
              var result = await showInfoDialog(
                context,
                message: "Se déconnecter ?",
                positiveLabel: "OUI",
                negativeLabel: "NON",
              );
              if (result != null && result) {
                profileController.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SigninScreen()),
                  (route) => false,
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.logout), Gap(8), const Text("Déconnexion")],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowInfo(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Text(value, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
