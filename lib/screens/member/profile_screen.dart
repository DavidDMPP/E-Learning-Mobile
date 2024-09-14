import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _npm;

  Future<void> _updateProfile(BuildContext context, String uid) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await DatabaseService().updateUserProfile(uid, _name, _npm);
      if (!mounted) return;
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: StreamBuilder<User>(
        stream: DatabaseService().getUserStream(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('User data not found'));
          }
          final userData = snapshot.data!;
          _name = userData.name;
          _npm = userData.npm;

          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _name,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a name' : null,
                    onSaved: (value) => _name = value!,
                  ),
                  TextFormField(
                    initialValue: _npm,
                    decoration: const InputDecoration(labelText: 'NPM'),
                    validator: (value) => value!.isEmpty ? 'Enter NPM' : null,
                    onSaved: (value) => _npm = value!,
                  ),
                  const SizedBox(height: 16),
                  Text('Role: ${userData.role}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _updateProfile(context, user.uid),
                    child: const Text('Update Profile'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
