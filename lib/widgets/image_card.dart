import 'dart:io';

import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final File file;

  const ImageCard({
    required this.file,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: Image.memory(
        file.readAsBytesSync(),
        fit: BoxFit.cover,
      ),
    );
  }
}
