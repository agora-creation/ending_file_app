import 'package:ending_file_app/common/functions.dart';
import 'package:ending_file_app/common/style.dart';
import 'package:ending_file_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  Future _openPasscode() async {
    String? passcode = await getPrefsString('passcode');
    if (passcode != null) {
      if (!mounted) return;
      await screenLock(
        context: context,
        correctString: passcode,
        title: const Text('画面がロックされました\nパスコードを入力してください'),
        canCancel: false,
        onUnlocked: () {
          Navigator.pop(context);
        },
        config: const ScreenLockConfig(
          backgroundColor: kBlackColor,
        ),
        keyPadConfig: KeyPadConfig(
          buttonConfig: KeyPadButtonConfig(
            foregroundColor: kWhiteColor,
            buttonStyle: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
              side: const BorderSide(color: kWhiteColor),
            ),
          ),
        ),
        deleteButton: const Icon(
          Icons.backspace,
          color: kWhiteColor,
        ),
      ).then((value) {
        pushReplacementScreen(context, const HomeScreen());
      });
    } else {
      if (!mounted) return;
      pushReplacementScreen(context, const HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBgDecoration,
      child: Scaffold(
        body: GestureDetector(
          onTap: () async {
            await _openPasscode();
          },
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
