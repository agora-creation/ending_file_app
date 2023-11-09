import 'package:ending_file_app/common/functions.dart';
import 'package:ending_file_app/common/style.dart';
import 'package:ending_file_app/widgets/custom_radio_list_tile.dart';
import 'package:flutter/material.dart';

class DeleteSettingScreen extends StatefulWidget {
  const DeleteSettingScreen({super.key});

  @override
  State<DeleteSettingScreen> createState() => _DeleteSettingScreenState();
}

class _DeleteSettingScreenState extends State<DeleteSettingScreen> {
  List<int> deleteDays = List<int>.generate(31, (index) => index);
  int checked = 0;

  void _init() async {
    int deleteDay = await getPrefsInt('deleteDay') ?? 0;
    setState(() {
      checked = deleteDay;
    });
  }

  Future _change(int value) async {
    await setPrefsInt('deleteDay', value);
    setState(() {
      checked = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBgDecoration.copyWith(color: kBlackColor),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('緊急削除設定'),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Text(
                'このアプリを一定期間開いていなかった場合、持ち主に何かあったとみなし、保存した画像を全て削除する機能です。',
              ),
              const SizedBox(height: 8),
              const Text(
                'アプリを閉じてから、何日後に削除するかをここで設定できます。',
              ),
              const SizedBox(height: 8),
              const Text(
                '※一定期間経った後、アプリを開いた時、必ず削除する前に、確認があります。削除をキャンセルするには、画面ロックのパスコードを入力することで、キャンセルできます。',
                style: TextStyle(color: kRedColor),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: deleteDays.length,
                  itemBuilder: (context, index) {
                    return CustomRadioListTile(
                      value: deleteDays[index],
                      groupValue: checked,
                      onChanged: (value) async {
                        await _change(value ?? 0);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
