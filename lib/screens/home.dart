import 'dart:async';
import 'dart:io';

import 'package:ending_file_app/common/functions.dart';
import 'package:ending_file_app/common/style.dart';
import 'package:ending_file_app/screens/audio_detail.dart';
import 'package:ending_file_app/screens/delete_setting.dart';
import 'package:ending_file_app/screens/image_detail.dart';
import 'package:ending_file_app/screens/video_detail.dart';
import 'package:ending_file_app/services/app_review.dart';
import 'package:ending_file_app/services/sqflite.dart';
import 'package:ending_file_app/widgets/audio_card.dart';
import 'package:ending_file_app/widgets/custom_sm_button.dart';
import 'package:ending_file_app/widgets/custom_text_button.dart';
import 'package:ending_file_app/widgets/image_card.dart';
import 'package:ending_file_app/widgets/purchase_list_tile.dart';
import 'package:ending_file_app/widgets/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:path/path.dart' as p;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

InAppPurchase _inAppPurchase = InAppPurchase.instance;
late StreamSubscription<dynamic> _streamSubscription;
List<ProductDetails> _products = [];
const _variant = {"ending_file_trial_release"};

void _listenToPurchase(
  List<PurchaseDetails> purchaseDetailsList,
  BuildContext context,
) {
  purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pending'),
      ));
    } else if (purchaseDetails.status == PurchaseStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error'),
      ));
    } else if (purchaseDetails.status == PurchaseStatus.purchased) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Purchased'),
      ));
    }
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  List<Map<String, dynamic>> files = [];

  Future _checkPasscode() async {
    String? passcode = await getPrefsString('passcode');
    if (passcode == null) {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Center(child: Text('画面のロック')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('画面をロックする設定がされていません。'),
              const Text('画面をロックするためのパスコードを設定してください。'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomSmButton(
                    label: 'パスコードを設定する',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () {
                      Navigator.pop(context);
                      _changePasscode();
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

  Future _openPasscode() async {
    String? passcode = await getPrefsString('passcode');
    int? lastTime = await getPrefsInt('lastTime');
    if (passcode != null && lastTime != null) {
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
          Navigator.pop(context);
        },
        config: kScreenLockConfig,
        keyPadConfig: kKeyPadConfig,
        deleteButton: const Icon(
          Icons.backspace,
          color: kWhiteColor,
        ),
      );
    }
  }

  void _changePasscode() async {
    await screenLockCreate(
      context: context,
      title: const Text('パスコードを入力してください'),
      confirmTitle: const Text('パスコードを再入力してください'),
      canCancel: false,
      onConfirmed: (value) async {
        await setPrefsString('passcode', value);
        if (!mounted) return;
        Navigator.pop(context);
      },
      config: kScreenLockConfig,
      keyPadConfig: kKeyPadConfig,
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

  Future _checkAppReview() async {
    int uploadCount = await getPrefsInt('uploadCount') ?? 0;
    bool appReview = await getPrefsBool('appReview') ?? false;
    if (uploadCount == 2 && !appReview) {
      if (!mounted) return;
      AppReviewService.launchStoreReview(context);
      await setPrefsBool('appReview', true);
    }
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
      }
      ids.add(entity.id);
    }
    await PhotoManager.editor.deleteWithIds(ids);
    int uploadCount = await getPrefsInt('uploadCount') ?? 0;
    await setPrefsInt('uploadCount', uploadCount + 1);
    _getFiles();
  }

  void _saveLastTime() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    await setPrefsInt('lastTime', timestamp);
  }

  void _initStore() async {
    ProductDetailsResponse productDetailsResponse =
        await _inAppPurchase.queryProductDetails(_variant);

    if (productDetailsResponse.error == null) {
      setState(() {
        _products = productDetailsResponse.productDetails;
      });
    }
  }

  void _buy() {
    final PurchaseParam param = PurchaseParam(productDetails: _products[0]);
    _inAppPurchase.buyConsumable(purchaseParam: param);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPasscode();
    _getFiles();
    _checkAppReview();

    Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

    _streamSubscription = purchaseUpdated.listen((purchaseList) {
      _listenToPurchase(purchaseList, context);
    }, onDone: () {
      _streamSubscription.cancel();
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error'),
      ));
    });

    _initStore();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        print('停止されたときの処理');
        _saveLastTime();
        break;
      case AppLifecycleState.resumed:
        print('再開されたときの処理');
        _openPasscode();
        break;
      case AppLifecycleState.detached:
        print('破棄されたときの処理');
        _saveLastTime();
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
              PurchaseListTile(
                onPressed: () {
                  _buy();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextButton(
                    onPressed: () => _changePasscode(),
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
                        gridDelegate: kGridDelegate,
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          bottom: 80,
                        ),
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = files[index];
                          File file = File(map['path']);
                          String extension = p.extension(file.path);
                          if (imageExtensions.contains(extension)) {
                            return GestureDetector(
                              onTap: () => pushScreen(
                                context,
                                ImageDetailScreen(map: map),
                              ),
                              child: ImageCard(file: file),
                            );
                          }
                          if (videoExtensions.contains(extension)) {
                            return GestureDetector(
                              onTap: () => pushScreen(
                                context,
                                VideoDetailScreen(map: map),
                              ),
                              child: VideoCard(file: file),
                            );
                          }
                          if (audioExtensions.contains(extension)) {
                            return GestureDetector(
                              onTap: () => pushScreen(
                                context,
                                AudioDetailScreen(map: map),
                              ),
                              child: AudioCard(file: file),
                            );
                          }
                          return Container();
                        },
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '保存されている画像がありません。',
                          ),
                          Text(
                            '右下のボタンから画像をアップロードしてください。',
                          ),
                        ],
                      ),
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
