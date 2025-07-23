import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/my_helper.dart';


class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  static bool _isShowingAd = false;
  static bool isLoaded = false;
  static String adsType = '';
  GetStorage sharedPref = GetStorage();

  void loadAd() async {
    bool isPremium = sharedPref.read(MyHelper.isAccountPremium) ?? false;
    adsType = sharedPref.read(MyHelper.adsType);
    if (adsType.contains("0") && !isPremium) {
      AppOpenAd.load(
        adUnitId: sharedPref.read(Platform.isAndroid?MyHelper.openAdsAndroid:MyHelper.openAdsIOS),
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _appOpenAd = ad;
            isLoaded = true;
          },
          onAdFailedToLoad: (error) {
            // Handle the error.
          },
        ),
      );
    }
  }

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable() {
    if (_appOpenAd == null) {
      debugPrint('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      debugPrint('Tried to show ad while already showing an ad.');
      return;
    }
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        debugPrint('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}
