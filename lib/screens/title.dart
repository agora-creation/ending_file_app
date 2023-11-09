import 'package:ending_file_app/common/functions.dart';
import 'package:ending_file_app/common/style.dart';
import 'package:ending_file_app/screens/home.dart';
import 'package:flutter/material.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBgDecoration,
      child: Scaffold(
        body: GestureDetector(
          onTap: () => pushReplacementScreen(context, const HomeScreen()),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'エンディングファイル',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kWhiteColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'このアプリは【終活】を目的としています。',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 24),
                          Text(
                            'スマートフォンの持ち主の身に何かあった場合、アルバムの中身が、何らかの形で漏れてしまうことがあります。',
                          ),
                          Text('このアプリであれば、それが解決します。'),
                          SizedBox(height: 24),
                          Text('◆このアプリで出来ること◆'),
                          Text('・アプリ内に、画像を保存できます。'),
                          Text('・画面ロック機能があり、第三者に見られるリスクを減らします。'),
                          Text(
                            '・しばらくアプリを開かなかった場合に、持ち主に何かあったとみなし、保存した画像を全て削除する機能があります。',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Text(
                    'タップしてはじめる',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
