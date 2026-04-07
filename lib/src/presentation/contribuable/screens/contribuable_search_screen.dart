import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tax_collect/src/presentation/contribuable/contribuable.dart';
import 'package:tax_collect/src/widgets/dialogs.dart';

class ContribuableSearchScreen extends ConsumerStatefulWidget {
  const ContribuableSearchScreen({super.key});

  @override
  ConsumerState<ContribuableSearchScreen> createState() =>
      _TaxCollectSearchScreenState();
}

class _TaxCollectSearchScreenState
    extends ConsumerState<ContribuableSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  late ContribuableController _contribuableController;

  @override
  void initState() {
    _contribuableController = ref.read(contribuableControllerProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nouvelle collecte")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Matricule ou nom...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_searchController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Veuillez entrer un matricule ou un nom"),
                    ),
                  );
                  return;
                }
                _search();
              },
              child: Text("Rechercher"),
            ),
          ],
        ),
      ),
    );
  }

  void _search() async {
    showLoadingDialog(context);
    var response = await _contribuableController.searchContribuable(
      _searchController.text,
    );
    Navigator.pop(context);
    if (response.success!) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContribuableDetailScreen()),
      );
      return;
    }
    showInfoDialog(
      context,
      message: response.message ?? "Erreur lors de la recherche",
    );
  }
}
