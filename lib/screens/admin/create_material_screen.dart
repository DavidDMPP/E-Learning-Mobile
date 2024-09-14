import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/database_service.dart';
import '../../services/storage_service.dart';

class CreateMaterialScreen extends StatefulWidget {
  const CreateMaterialScreen({super.key});

  @override
  CreateMaterialScreenState createState() => CreateMaterialScreenState();
}

class CreateMaterialScreenState extends State<CreateMaterialScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  String _category = '';
  String _youtubeLink = '';
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> _createMaterial() async {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();
      final String imageUrl = await StorageService().uploadFile(_image!);
      await DatabaseService().createMaterial(
          _name, _description, _category, imageUrl, _youtubeLink);
      if (!mounted) return;
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Material created successfully')),
        );
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Material')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter a name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a description' : null,
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a category' : null,
                onSaved: (value) => _category = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'YouTube Link'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a YouTube link' : null,
                onSaved: (value) => _youtubeLink = value!,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              if (_image != null) Text('Image selected: ${_image!.path}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _createMaterial,
                child: const Text('Create Material'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
