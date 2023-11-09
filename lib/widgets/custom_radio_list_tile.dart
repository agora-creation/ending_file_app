import 'package:flutter/material.dart';

class CustomRadioListTile extends StatelessWidget {
  final int value;
  final int? groupValue;
  final Function(int?)? onChanged;

  const CustomRadioListTile({
    required this.value,
    this.groupValue,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: RadioListTile(
        title: Text(value == 0 ? '削除しない' : '$value日後に削除する'),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    );
  }
}
