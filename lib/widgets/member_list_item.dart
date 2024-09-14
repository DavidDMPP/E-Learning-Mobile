import 'package:flutter/material.dart';
import '../models/user.dart';

class MemberListItem extends StatelessWidget {
  final User user;

  const MemberListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.npm),
      trailing: Text(user.role),
    );
  }
}
