import 'package:flutter/material.dart';
import '../models/material.dart';

class MaterialListItem extends StatelessWidget {
  final StudyMaterial material;
  final VoidCallback onTap;

  const MaterialListItem({super.key, required this.material, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(material.photoUrl,
          width: 50, height: 50, fit: BoxFit.cover),
      title: Text(material.name),
      subtitle: Text(material.category),
      onTap: onTap,
    );
  }
}
