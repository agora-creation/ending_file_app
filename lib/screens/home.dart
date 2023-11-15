import 'dart:io';

import 'package:ending_file_app/common/functions.dart';
import 'package:ending_file_app/common/style.dart';
import 'package:ending_file_app/screens/delete_setting.dart';
import 'package:ending_file_app/services/sqflite.dart';
import 'package:ending_file_app/widgets/custom_sm_button.dart';
import 'package:ending_file_app/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:path/path.dart' as p;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  List<Map<String, dynamic>> files = [];

  Future _init() async {
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
              const Text('画面ロックの設定がされていません。'),
              const Text('画面ロックするためのパスコードを設定してください。'),
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
      title: const Text('パスコードを再設定します\nパスコードを入力してください'),
      confirmTitle: const Text('パスコードを再設定します\n先ほど入力したパスコードを再入力してください'),
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

  Future _getFiles() async {
    List<Map<String, dynamic>> tmpFiles = await SqfLiteService.getFolder();
    setState(() {
      files = tmpFiles;
    });
  }

  Future _uploadFiles() async {
    PermissionState ps = await AssetPicker.permissionCheck();
    if (!ps.hasAccess) return;
    if (!mounted) return;
    List<AssetEntity>? result = await AssetPicker.pickAssets(context);
    if (result == null) return;
    if (result.isEmpty) return;
    List<String> ids = [];
    for (AssetEntity entity in result) {
      File? file = await entity.originFile;
      if (file != null) {
        await SqfLiteService.savedFile(file);
        _getFiles();
      }
      ids.add(entity.id);
    }
    await PhotoManager.editor.deleteWithIds(ids);
  }

  @override
  void initState() {
    _init();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getFiles();
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
                    label: 'パスコード再設定',
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
                child: files.isNotEmpty
                    ? GridView.builder(
                        gridDelegate: kHomeGridDelegate,
                        padding: const EdgeInsets.all(8),
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> file = files[index];
                          File fileData = File(file['path']);
                          String extension = p.extension(fileData.path);
                          if (imageExtensions.contains(extension)) {}
                          if (videoExtensions.contains(extension)) {}
                          if (audioExtensions.contains(extension)) {}
                          return const Card(
                            child: Text('写真'),
                          );
                        },
                      )
                    : const Center(child: Text('保存されている画像がありません')),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await _uploadFiles();
          },
          label: const Text('画像をアップロード'),
          icon: const Icon(Icons.add_photo_alternate),
        ),
      ),
    );
  }
}
