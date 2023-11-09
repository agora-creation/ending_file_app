import 'package:ending_file_app/common/style.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String label;
  final Function()? onPressed;

  const CustomTextButton({
    required this.label,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          color: kWhiteColor,
          fontSize: 18,
        ),
      ),
    );
  }
}
