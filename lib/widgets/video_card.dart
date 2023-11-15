import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoCard extends StatefulWidget {
  final File file;

  const VideoCard({
    required this.file,
    Key? key,
  }) : super(key: key);

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  Widget imageWidget = Container();

  void _init() async {
    final bytes = await VideoThumbnail.thumbnailData(
      video: widget.file.path,
      imageFormat: ImageFormat.JPEG,
      quality: 25,
    );
    if (bytes == null) return;
    setState(() {
      imageWidget = Image.memory(
        bytes,
        fit: BoxFit.cover,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: imageWidget,
    );
  }
}
