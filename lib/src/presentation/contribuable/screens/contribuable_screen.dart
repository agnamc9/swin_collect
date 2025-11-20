import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tax_collect/src/presentation/contribuable/contribuable.dart';
import 'package:tax_collect/src/widgets/api_response_view.dart';

class ContribuableScreen extends ConsumerStatefulWidget {
  const ContribuableScreen({super.key});

  @override
  ConsumerState<ContribuableScreen> createState() => _ContribuableScreenState();
}

class _ContribuableScreenState extends ConsumerState<ContribuableScreen> {
  final TextEditingController _searchController = TextEditingController();

  late ContribuableController _contribuableController;

  @override
  void initState() {
    _contribuableController = ref.read(contribuableControllerProvider);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getContribuables();
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
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                filled: true,
                fillColor: Colors.white,
              ),
              obscureText: true,
            ),
            Gap(8),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  _contribuableController = ref.watch(contribuableControllerProvider);
                  var response = _contribuableController.contribuableResponse;
                  return ApiResponseView(
                    response: response,
                    retry: _getContribuables,
                    responseBuilder: (items) {
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          var item = items.elementAt(index);
                          return InkWell(
                            onTap: () {
                              _contribuableController.contribuable = item;
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ContribuableDetailScreen()),
                              );
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(),
                                    Gap(8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            item.fullname,
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          Text(item.matricule ?? ""),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => Gap(8),
                        itemCount: items.length,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateContribuableScreen()),
          );
          if (result != null) {
            _getContribuables();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _getContribuables() {
    _contribuableController.getContribuables();
  }
}
