import 'dart:io';

import 'package:ending_file_app/common/functions.dart';
import 'package:ending_file_app/common/style.dart';
import 'package:ending_file_app/screens/home.dart';
import 'package:ending_file_app/services/sqflite.dart';
import 'package:ending_file_app/widgets/custom_sm_button.dart';
import 'package:ending_file_app/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AudioDetailScreen extends StatefulWidget {
  final Map<String, dynamic> map;

  const AudioDetailScreen({
    required this.map,
    super.key,
  });

  @override
  State<AudioDetailScreen> createState() => _AudioDetailScreenState();
}

class _AudioDetailScreenState extends State<AudioDetailScreen> {
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
    File file = File(widget.map['path']);

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
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('本当に削除しますか？'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomSmButton(
                            label: 'やめる',
                            labelColor: kWhiteColor,
                            backgroundColor: kGreyColor,
                            onPressed: () => Navigator.pop(context),
                          ),
                          CustomSmButton(
                            label: 'はい',
                            labelColor: kWhiteColor,
                            backgroundColor: kRedColor,
                            onPressed: () async {
                              await SqfLiteService.removedFile(
                                widget.map['id'],
                              );
                              await file.delete();
                              if (!mounted) return;
                              pushReplacementScreen(
                                context,
                                const HomeScreen(),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                barrierDismissible: false,
              ),
              label: '削除する',
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Icon(
                Icons.music_video,
                size: 128,
                color: Colors.white,
              ),
            ),
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
