import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/material.dart';

class MaterialDetailScreen extends StatelessWidget {
  final StudyMaterial material;

  const MaterialDetailScreen({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(material.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse(material.youtubeLink);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Could not open YouTube link')),
                    );
                  }
                },
                child: Image.network(material.photoUrl),
              ),
              const SizedBox(height: 16),
              Text('Category: ${material.category}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(material.description),
            ],
          ),
        ),
      ),
    );
  }
}
