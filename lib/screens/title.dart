import 'dart:io';

import 'package:ending_file_app/common/functions.dart';
import 'package:ending_file_app/common/style.dart';
import 'package:ending_file_app/screens/home.dart';
import 'package:ending_file_app/services/sqflite.dart';
import 'package:ending_file_app/widgets/custom_sm_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  void _checkPasscode() async {
    DateTime now = DateTime.now();
    String? passcode = await getPrefsString('passcode');
    int? timestamp = await getPrefsInt('lastTime');
    int? deleteDay = await getPrefsInt('deleteDay');
    if (passcode != null && timestamp != null && deleteDay != null) {
      DateTime lastTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      Duration diff = now.difference(lastTime);
      int daysDiff = diff.inDays;
      if (daysDiff >= deleteDay) {
        //削除アラート
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: kRedColor,
            title: const Center(child: Text('警告')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('アプリを閉じてから、$daysDiff日が経過しました。'),
                const SizedBox(height: 8),
                const Text(
                  'これから緊急削除プログラムを実行しますが、最終確認のため、あなたに、このアプリに設定されているパスコードの認証を行っていただきます。',
                ),
                const Text('パスコードが一致すれば、緊急削除プログラムは停止され、いつも通りご利用いただけます。'),
                const Text('パスコードが一致しなければ、緊急削除プログラムが実行されます。'),
                const SizedBox(height: 8),
                const Text('緊急削除プログラムが実行されると、アプリ内のデータは全て削除され、アプリは自動で閉じます。'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomSmButton(
                      label: 'パスコード認証を行う',
                      labelColor: kWhiteColor,
                      backgroundColor: kBlueColor,
                      onPressed: () async {
                        int errorCount = 0;
                        await screenLock(
                          context: context,
                          correctString: passcode,
                          title: const Column(
                            children: [
                              Text('パスコードを入力してください'),
                              Text(
                                '3回間違えると、アプリが自動で閉じます。',
                                style: kLockErrorStyle,
                              )
                            ],
                          ),
                          canCancel: false,
                          onError: (value) async {
                            errorCount++;
                            if (errorCount == 3) {
                              await allRemovePrefs();
                              await SqfLiteService.removedFiles();
                              if (Platform.isAndroid) {
                                SystemNavigator.pop();
                              } else if (Platform.isIOS) {
                                exit(0);
                              }
                            }
                          },
                          onUnlocked: () async {
                            await removePrefs('lastTime');
                            if (!mounted) return;
                            pushReplacementScreen(context, const HomeScreen());
                          },
                          config: kScreenLockConfig,
                          keyPadConfig: kKeyPadConfig,
                          deleteButton: const Icon(
                            Icons.backspace,
                            color: kWhiteColor,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        int errorCount = 0;
        if (!mounted) return;
        await screenLock(
          context: context,
          correctString: passcode,
          title: const Column(
            children: [
              Text('パスコードを入力してください'),
              Text(
                '3回間違えると、アプリが自動で閉じます。',
                style: kLockErrorStyle,
              )
            ],
          ),
          canCancel: false,
          onError: (value) async {
            errorCount++;
            if (errorCount == 3) {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            }
          },
          onUnlocked: () async {
            await removePrefs('lastTime');
            if (!mounted) return;
            pushReplacementScreen(context, const HomeScreen());
          },
          config: kScreenLockConfig,
          keyPadConfig: kKeyPadConfig,
          deleteButton: const Icon(
            Icons.backspace,
            color: kWhiteColor,
          ),
        );
      }
    } else {
      if (passcode != null) {
        int errorCount = 0;
        if (!mounted) return;
        await screenLock(
          context: context,
          correctString: passcode,
          title: const Column(
            children: [
              Text('パスコードを入力してください'),
              Text(
                '3回間違えると、アプリが自動で閉じます。',
                style: kLockErrorStyle,
              )
            ],
          ),
          canCancel: false,
          onError: (value) async {
            errorCount++;
            if (errorCount == 3) {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            }
          },
          onUnlocked: () async {
            await removePrefs('lastTime');
            if (!mounted) return;
            pushReplacementScreen(context, const HomeScreen());
          },
          config: kScreenLockConfig,
          keyPadConfig: kKeyPadConfig,
          deleteButton: const Icon(
            Icons.backspace,
            color: kWhiteColor,
          ),
        );
      } else {
        await removePrefs('lastTime');
        if (!mounted) return;
        pushReplacementScreen(context, const HomeScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBgDecoration,
      child: Scaffold(
        body: GestureDetector(
          onTap: () => _checkPasscode(),
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
                    decoration: kBorderDecoration,
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
