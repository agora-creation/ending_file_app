import 'package:ending_file_app/common/functions.dart';
import 'package:ending_file_app/common/style.dart';
import 'package:ending_file_app/screens/delete_setting.dart';
import 'package:ending_file_app/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBgDecoration,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextButton(
                    onPressed: () {},
                    label: '画面ロック設定',
                  ),
                  CustomTextButton(
                    onPressed: () => showBottomUpScreen(
                      context,
                      const DeleteSettingScreen(),
                    ),
                    label: '緊急削除設定',
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    crossAxisCount: 3,
                  ),
                  padding: const EdgeInsets.all(8),
                  itemCount: 50,
                  itemBuilder: (context, index) {
                    return const Card(
                      child: Text('写真'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: const Text('画像をアップロード'),
          icon: const Icon(Icons.add_photo_alternate),
        ),
      ),
    );
  }
}
