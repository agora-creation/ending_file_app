import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class AppReviewService {
  static final InAppReview _inAppReview = InAppReview.instance;

  static const String _urlAppStore =
      'https://apps.apple.com/jp/app/id6472276129';
  static const String _urlPlayStore =
      'https://play.google.com/store/apps/details?id=com.agoracreation.ending_file_app';

  static void launchStoreReview(BuildContext context) async {
    try {
      if (await _inAppReview.isAvailable()) {
        _inAppReview.requestReview();
      } else {
        final url = Platform.isIOS ? _urlAppStore : _urlPlayStore;

        if (!await launchUrl(Uri.parse(url))) {
          throw 'Cannot launch the store URL';
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
