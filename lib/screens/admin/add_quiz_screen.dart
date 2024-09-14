import 'package:flutter/material.dart';
import '../../services/database_service.dart';

class AddQuizScreen extends StatefulWidget {
  const AddQuizScreen({super.key});

  @override
  AddQuizScreenState createState() => AddQuizScreenState();
}

class AddQuizScreenState extends State<AddQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  String _question = '';
  final List<String> _options = ['', '', '', ''];
  int _correctOptionIndex = 0;

  Future<void> _addQuizQuestion() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await DatabaseService()
          .addQuizQuestion(_question, _options, _correctOptionIndex);
      if (!mounted) return;
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quiz question added successfully')),
        );
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Quiz Question')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Question'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a question' : null,
                onSaved: (value) => _question = value!,
              ),
              const SizedBox(height: 16),
              ...List.generate(4, (index) {
                return TextFormField(
                  decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter an option' : null,
                  onSaved: (value) => _options[index] = value!,
                );
              }),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Correct Option'),
                value: _correctOptionIndex,
                items: List.generate(4, (index) {
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text('Option ${index + 1}'),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    _correctOptionIndex = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addQuizQuestion,
                child: const Text('Add Quiz Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
