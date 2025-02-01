import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sqlite/Models/borrower.dart';
import 'package:get/get.dart';
import '../Data/database_helper.dart';

class AddBorrowerPage extends StatefulWidget {
  const AddBorrowerPage({super.key});

  @override
  State<AddBorrowerPage> createState() => _AddBorrowerPageState();
}

class _AddBorrowerPageState extends State<AddBorrowerPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  Future<void> _saveBorrower() async {
    if (_formKey.currentState!.validate()) {
      Borrower newBorrower = Borrower(
        fullname: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      await DatabaseHelper().insertBorrower(newBorrower);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Borrower added successfully!')),
      );

      Get.offAllNamed("/borrowers");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Borrower')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveBorrower,
                child: Text('Save Borrower'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
