import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sqlite/Data/database_helper.dart';
import 'package:get/get.dart';

import '../Models/borrower.dart';
import '../Models/loan.dart';

class AddLoanPage extends StatefulWidget {
  @override
  _AddLoanPageState createState() => _AddLoanPageState();
}

class _AddLoanPageState extends State<AddLoanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  Rxn<Borrower> _selectedBorrower = Rxn();

  RxList<Borrower> borrowers = RxList<Borrower>();
  RxBool loading = RxBool(false);

  getBorrowers() async {
    try {
      loading.value = true;
      borrowers.value = await DatabaseHelper().getBorrowers();
    } catch (e) {
    } finally {
      loading.value = false;
    }
  }

  Future<void> _saveLoan() async {
    if (_formKey.currentState!.validate()) {
      Loan newLoan = Loan(
        borrowerId: _selectedBorrower.value!.id!,
        amount: double.parse(_amountController.text.trim()),
        date: _dateController.text.trim(),
      );

      await DatabaseHelper().insertLoan(newLoan);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loan added successfully!')),
      );

      Get.offAllNamed("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    getBorrowers();
    return Scaffold(
      appBar: AppBar(title: Text('Add Loan')),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<Borrower>(
                  value: _selectedBorrower.value,
                  items: borrowers.map((borrower) {
                    return DropdownMenuItem(
                      value: borrower,
                      child: Text(borrower.fullname),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _selectedBorrower.value = value!;
                  },
                  decoration: InputDecoration(labelText: 'Select Borrower'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: 'Loan Amount (IQD)'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the loan amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _dateController,
                  decoration:
                      InputDecoration(labelText: 'Loan Date (DD-MM-YYYY)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveLoan,
                  child: Text('Save Loan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
