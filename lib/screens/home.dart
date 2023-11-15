import 'package:ending_file_app/common/functions.dart';
import 'package:ending_file_app/common/style.dart';
import 'package:ending_file_app/screens/delete_setting.dart';
import 'package:ending_file_app/widgets/custom_sm_button.dart';
import 'package:ending_file_app/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Future _init() async {
    String? passcode = await getPrefsString('passcode');
    if (passcode != null) {
      if (!mounted) return;
      await screenLock(
        context: context,
        correctString: passcode,
        title: const Text('パスコードを入力してください'),
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
      );
    } else {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('画面ロック設定がされていません。'),
              const Text('画面ロックに必要なパスコートを設定してください。'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomSmButton(
                    label: '設定する',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () async {
                      Navigator.pop(context);
                      await _changePasscode();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  Future _changePasscode() async {
    await screenLockCreate(
      context: context,
      title: const Text('パスコードを入力してください'),
      confirmTitle: const Text('同じパスコードを再入力してください'),
      canCancel: false,
      onConfirmed: (value) async {
        await setPrefsString('passcode', value);
        if (!mounted) return;
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
      cancelButton: const Icon(
        Icons.close,
        color: kWhiteColor,
      ),
      deleteButton: const Icon(
        Icons.backspace,
        color: kWhiteColor,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        print('非アクティブになったときの処理');
        break;
      case AppLifecycleState.paused:
        print('停止されたときの処理');
        break;
      case AppLifecycleState.resumed:
        print('再開されたときの処理');
        _init();
        break;
      case AppLifecycleState.detached:
        print('破棄されたときの処理');
        break;
      default:
        break;
    }
  }

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
                    onPressed: () async {
                      await _changePasscode();
                    },
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
