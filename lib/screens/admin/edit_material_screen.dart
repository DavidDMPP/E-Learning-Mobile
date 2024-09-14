import 'package:flutter/material.dart';
import '../../models/material.dart';
import '../../services/database_service.dart';

class EditMaterialScreen extends StatefulWidget {
  final StudyMaterial material;

  const EditMaterialScreen({super.key, required this.material});

  @override
  EditMaterialScreenState createState() => EditMaterialScreenState();
}

class EditMaterialScreenState extends State<EditMaterialScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late String _category;
  late String _youtubeLink;

  @override
  void initState() {
    super.initState();
    _name = widget.material.name;
    _description = widget.material.description;
    _category = widget.material.category;
    _youtubeLink = widget.material.youtubeLink;
  }

  Future<void> _updateMaterial() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await DatabaseService().updateMaterial(
        widget.material.id,
        _name,
        _description,
        _category,
        _youtubeLink,
      );
      if (!mounted) return;
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Material updated successfully')),
        );
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Material')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter a name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a description' : null,
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a category' : null,
                onSaved: (value) => _category = value!,
              ),
              TextFormField(
                initialValue: _youtubeLink,
                decoration: const InputDecoration(labelText: 'YouTube Link'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a YouTube link' : null,
                onSaved: (value) => _youtubeLink = value!,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateMaterial,
                child: const Text('Update Material'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
