import 'dart:io';

import 'package:ending_file_app/common/functions.dart';
import 'package:ending_file_app/common/style.dart';
import 'package:ending_file_app/screens/home.dart';
import 'package:ending_file_app/services/sqflite.dart';
import 'package:ending_file_app/widgets/custom_sm_button.dart';
import 'package:ending_file_app/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

class ImageDetailScreen extends StatefulWidget {
  final Map<String, dynamic> map;

  const ImageDetailScreen({
    required this.map,
    super.key,
  });

  @override
  State<ImageDetailScreen> createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
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
        body: Center(
          child: Image.memory(
            file.readAsBytesSync(),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
