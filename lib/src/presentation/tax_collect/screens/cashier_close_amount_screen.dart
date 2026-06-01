import 'package:flutter/material.dart';

class CashierCloseAmountScreen extends StatefulWidget {
  const CashierCloseAmountScreen({super.key});

  @override
  State<CashierCloseAmountScreen> createState() => _CashierCloseAmountScreenState();
}

class _CashierCloseAmountScreenState extends State<CashierCloseAmountScreen> {
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Clôture de la caisse",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: "Montant total collecté",
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Le montant est requis";
                    }

                    try {
                      final amount = int.parse(value.trim());
                      if (amount <= 0) {
                        return "Le montant doit être positif";
                      }
                    } catch (e) {
                      return "Le montant est invalide";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if(!_formKey.currentState!.validate()) return;
                    Navigator.pop(context, int.parse(_amountController.text.trim()));
                  },
                  child: Text('Valider'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
