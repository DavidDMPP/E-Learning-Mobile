import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/user.dart';

class MemberApprovalScreen extends StatelessWidget {
  const MemberApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Member Approval')),
      body: StreamBuilder<List<User>>(
        stream: DatabaseService().getPendingMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pending members'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.npm),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () =>
                          DatabaseService().approveMember(user.uid),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => DatabaseService().rejectMember(user.uid),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
