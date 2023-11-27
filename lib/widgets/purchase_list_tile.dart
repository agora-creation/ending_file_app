import 'package:ending_file_app/common/style.dart';
import 'package:flutter/material.dart';

class PurchaseListTile extends StatelessWidget {
  final Function()? onPressed;

  const PurchaseListTile({
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: kRedColor,
      title: const Text(
        '現在は試用版です',
        style: TextStyle(
          color: kYellowColor,
          fontSize: 14,
        ),
      ),
      trailing: TextButton(
        child: const Text(
          '製品版を購入',
          style: TextStyle(
            color: kYellowColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}
