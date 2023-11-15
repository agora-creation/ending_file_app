import 'dart:io';

import 'package:ending_file_app/common/style.dart';
import 'package:ending_file_app/services/sqflite.dart';
import 'package:ending_file_app/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDetailScreen extends StatefulWidget {
  final Map<String, dynamic> map;

  const VideoDetailScreen({
    required this.map,
    super.key,
  });

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  late VideoPlayerController controller;

  void _init() async {
    File file = File(widget.map['path']);
    controller = VideoPlayerController.file(file);
    controller.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBgDecoration.copyWith(color: kBlackColor),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.chevron_left),
          ),
          actions: [
            CustomTextButton(
              onPressed: () async {
                await SqfLiteService.removedFile(widget.map['id']);
                if (!mounted) return;
                Navigator.pop(context);
              },
              label: '削除する',
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: VideoPlayer(controller)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    controller
                        .seekTo(Duration.zero)
                        .then((_) => controller.play());
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => controller.play(),
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => controller.pause(),
                  icon: const Icon(Icons.pause, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
