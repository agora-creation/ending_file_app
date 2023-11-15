import 'dart:io';

import 'package:flutter/material.dart';

class AudioCard extends StatelessWidget {
  final File file;

  const AudioCard({
    required this.file,
    Key? key,
  }) : super(key: key);

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
