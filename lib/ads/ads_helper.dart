import 'dart:io';
import 'package:facebook_audience_network/ad/ad_banner.dart' as fb;
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/ad/ad_rewarded.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import '../utils/my_color.dart';
import '../utils/my_helper.dart';
import 'ads_callback.dart';
import 'package:get/get.dart';

InterstitialAd? _interstitialAd;
String interCode = "";
String bannerCode = "";
String adsType = '';
String placementId = '';
String appKey = '';
GetStorage sharedPref = GetStorage();

class AdsHelper {
  final AdsCallBack _adsController = Get.find<AdsCallBack>();

  RewardedAd? _rewardedAd;

  initialization() async {
    adsType = sharedPref.read(MyHelper.adsType);
    _adsController.isPremium.value =
        sharedPref.read(MyHelper.isAccountPremium) ?? false;

    if (adsType.contains("0") && !_adsController.isPremium.value) {
      interCode = sharedPref.read(
          Platform.isAndroid ? MyHelper.interAdsAndroid : MyHelper.interAdsIos);
      bannerCode = sharedPref.read(Platform.isAndroid
          ? MyHelper.bannerAdsAndroid
          : MyHelper.bannerAdsIos);
      createInterAd();
    } else if (adsType.contains("1") && !_adsController.isPremium.value) {
      interCode = sharedPref.read(Platform.isAndroid
          ? MyHelper.fbInterAdsAndroid
          : MyHelper.fbInterAdsIos);
      bannerCode = sharedPref.read(Platform.isAndroid
          ? MyHelper.fbBannerAdsAndroid
          : MyHelper.fbBannerAdsIos);
      loadFbInterstitialAd();
    } else if (adsType.contains("2") && !_adsController.isPremium.value) {
      placementId = sharedPref.read(Platform.isAndroid
          ? MyHelper.unityAdsInterAndroid
          : MyHelper.unityAdsInterIos);
      loadUnityIntAd();
    } else if (adsType.contains("3") && !_adsController.isPremium.value) {
      appKey = sharedPref.read(MyHelper.ironAdsAppId);
      await initIronSource();
    }
  }

  // -----------------------
  // AdMob Interstitial Ads
  // -----------------------
  void createInterAd() {
    InterstitialAd.load(
      adUnitId: interCode,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  void showInterAd() {
    if (adsType.contains("0") && !_adsController.isPremium.value) {
      if (_interstitialAd == null) {
        createInterAd();
        return;
      }
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          debugPrint("AdMob interstitial is showing.");
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          debugPrint("AdMob interstitial dismissed.");
          ad.dispose();
          createInterAd();
          _adsController.setDismiss();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          debugPrint("AdMob interstitial failed: $error");
          ad.dispose();
          createInterAd();
          _adsController.setFailed();
        },
      );
      _interstitialAd!.show();
    } else if (adsType.contains("1") && !_adsController.isPremium.value) {
      showFbInterstitialAd();
    } else if (adsType.contains("2") && !_adsController.isPremium.value) {
      showUnityIntAd();
    } else if (adsType.contains("3") && !_adsController.isPremium.value) {
      showIronSourceInterstitialAd();
    }
  }

  // -----------------------
  // Unity Interstitial Ads
  // -----------------------
  static Future<void> loadUnityIntAd() async {
    await UnityAds.load(
      placementId: placementId,
      onComplete: (placementId) =>
          debugPrint('Unity interstitial loaded: $placementId'),
      onFailed: (placementId, error, message) => debugPrint(
          'Unity interstitial failed: $placementId, $error, $message'),
    );
  }

  static Future<void> showUnityIntAd() async {
    UnityAds.showVideoAd(
      placementId: placementId,
      onStart: (placementId) =>
          debugPrint('Unity video ad started: $placementId'),
      onClick: (placementId) =>
          debugPrint('Unity video ad clicked: $placementId'),
      onSkipped: (placementId) =>
          debugPrint('Unity video ad skipped: $placementId'),
      onComplete: (placementId) async {
        await loadUnityIntAd();
      },
      onFailed: (placementId, error, message) async {
        await loadUnityIntAd();
      },
    );
  }

  // -----------------------
  // Facebook Interstitial Ads
  // -----------------------
  bool _fbisInterstitialAdLoaded = false;

  Future loadFbInterstitialAd() async {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: interCode,
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          _fbisInterstitialAdLoaded = true;
        } else if (result == InterstitialAdResult.ERROR) {
          debugPrint("Facebook interstitial error: $value");
        } else if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _fbisInterstitialAdLoaded = false;
          loadFbInterstitialAd();
        }
      },
    );
  }

  void showFbInterstitialAd() {
    if (_fbisInterstitialAdLoaded == true) {
      FacebookInterstitialAd.showInterstitialAd();
    }
  }

  // -----------------------
  // IronSource Interstitial Ads
  // -----------------------

  Future<void> initIronSource() async {
    var userId = await IronSource.getAdvertiserId();
    await IronSource.validateIntegration();
    await IronSource.setUserId(userId);
    await IronSource.init(
      appKey: appKey,
      initListener: IronInterAdListener(),
    );
  }

  static Future<void> loadIronSourceInterstitialAd() async {
    await IronSource.loadInterstitial();
  }

  static Future<void> showIronSourceInterstitialAd() async {
    if (await IronSource.isInterstitialReady()) {
      IronSource.showInterstitial();
    } else {
      loadIronSourceInterstitialAd();
    }
  }

  // -----------------------
  // Unity Banner Ads
  // -----------------------
  Widget showUnityBannerAd() {
    return UnityBannerAd(
      placementId: Platform.isAndroid ? "Banner_Android" : "Banner_Ios",
      onClick: (placementId) =>
          debugPrint("Unity banner clicked: $placementId"),
      onFailed: (placementId, error, message) async {
        await loadUnityBannerAd();
      },
      onLoad: (value) async {
        await loadUnityBannerAd();
        _adsController.isBannerLoaded.value = true;
        debugPrint("Unity banner loaded: $value");
      },
    );
  }

  static Future<void> loadUnityBannerAd() async {
    await UnityAds.load(
      placementId: Platform.isAndroid ? "Banner_Android" : "Banner_Ios",
      onComplete: (placementId) =>
          debugPrint("Unity banner load complete: $placementId"),
      onFailed: (placementId, error, message) => debugPrint(
          "Unity banner load failed: $placementId, $error, $message"),
    );
  }

  // -----------------------
  // AdMob Banner Ads
  // -----------------------
  BannerAd getBannerAd() {
    BannerAd bAd = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerCode,
      listener: BannerAdListener(
        onAdClosed: (Ad ad) {},
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
        onAdLoaded: (Ad ad) {
          _adsController.isBannerLoaded.value = true;
        },
        onAdOpened: (Ad ad) {},
      ),
      request: const AdRequest(),
    );
    bAd.load();
    return bAd;
  }

  // -----------------------
  // Facebook Banner Ads
  // -----------------------
  Widget showFbBanner() {
    return FacebookBannerAd(
      placementId: bannerCode,
      bannerSize: fb.BannerSize.STANDARD,
      listener: (result, value) {
        if (result == fb.BannerAdResult.LOADED) {
          _adsController.isBannerLoaded.value = true;
        }
      },
    );
  }

  // -----------------------
  // IronSource Banner Ads
  // -----------------------
  static Widget showIronSourceBannerAd() {
    return LevelPlayBannerAdView(
      adSize: LevelPlayAdSize.BANNER,
      listener: IronBannerAdListener(),
      onPlatformViewCreated: () {},
      adUnitId: '',
    );
  }

  AdWidget buildAdWidget() {
    return AdWidget(ad: getBannerAd());
  }

  // -----------------------
  // Banner Display Widget
  // -----------------------
  Widget showBanner() {
    if (adsType.contains("0") && !_adsController.isPremium.value) {
      return buildAdWidget();
    } else if (adsType.contains("2") && !_adsController.isPremium.value) {
      return showUnityBannerAd();
    } else if (adsType.contains("1") && !_adsController.isPremium.value) {
      return showFbBanner();
    } else if (adsType.contains("3") && !_adsController.isPremium.value) {
      return showIronSourceBannerAd();
    } else {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    }
  }

  //Reward

  // AdMob Rewarded Ads

  void createRewardedAd() {
    RewardedAd.load(
      adUnitId: sharedPref.read(Platform.isAndroid
          ? MyHelper.rewardAdsAndroid
          : MyHelper.rewardAdsIos),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
        },
      ),
    );
  }

  void showRewardedAdAdMob() {
    if (_rewardedAd == null) {
      createRewardedAd();
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        debugPrint("AdMob rewarded ad is showing.");
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint("AdMob rewarded ad dismissed.");
        ad.dispose();
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint("AdMob rewarded ad failed: $error");
        ad.dispose();
        createRewardedAd();
      },
    );
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint('User earned a reward: ${reward.amount}');
      },
    );
  }

  // Unity Rewarded Ads
  static String unityRewardedPlacementId =
      Platform.isAndroid ? "Rewarded_Android" : "Rewarded_Ios";

  static Future<void> loadUnityRewardedAd() async {
    await UnityAds.load(
      placementId: unityRewardedPlacementId,
      onComplete: (placementId) =>
          debugPrint('Unity rewarded ad loaded: $placementId'),
      onFailed: (placementId, error, message) => debugPrint(
          'Unity rewarded ad failed: $placementId, $error, $message'),
    );
  }

  static Future<void> showUnityRewardedAd() async {
    UnityAds.showVideoAd(
      placementId: unityRewardedPlacementId,
      onStart: (placementId) =>
          debugPrint('Unity rewarded ad started: $placementId'),
      onClick: (placementId) =>
          debugPrint('Unity rewarded ad clicked: $placementId'),
      onSkipped: (placementId) =>
          debugPrint('Unity rewarded ad skipped: $placementId'),
      onComplete: (placementId) async {
        await loadUnityRewardedAd();
        debugPrint('Unity rewarded ad completed: $placementId');
      },
      onFailed: (placementId, error, message) async {
        await loadUnityRewardedAd();
        debugPrint('Unity rewarded ad failed: $placementId, $error, $message');
      },
    );
  }

  bool loadedReward = false;

  // Facebook Rewarded Ads
  void loadFbRewardedAd() {
    FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: sharedPref.read(Platform.isAndroid
          ? MyHelper.fbRewardAdsAndroid
          : MyHelper.fbRewardAdsIos),
      listener: (result, value) {
        if (result == RewardedVideoAdResult.LOADED) {
          loadedReward = true;
          debugPrint("Facebook rewarded video loaded.");
        } else if (result == RewardedVideoAdResult.ERROR) {
          debugPrint("Facebook rewarded video error: $value");
        } else if (result == RewardedVideoAdResult.VIDEO_COMPLETE) {
          debugPrint("Facebook rewarded video completed: $value");
        } else if (result == RewardedVideoAdResult.VIDEO_CLOSED) {
          debugPrint("Facebook rewarded video closed.");
        }
      },
    );
  }

  void showFbRewardedAd() {
    if (loadedReward) {
      FacebookRewardedVideoAd.showRewardedVideoAd();
    } else {
      loadFbRewardedAd();
    }
  }

  // IronSource Rewarded Ads
  Future<void> loadIronSourceRewardedAd() async {
    await IronSource.loadRewardedVideo();
  }

  Future<void> showIronSourceRewardedAd() async {
    if (await IronSource.isRewardedVideoAvailable()) {
      IronSource.showRewardedVideo();
    } else {
      await loadIronSourceRewardedAd();
    }
  }

  void showRewardedAd() {
    if (adsType.contains("0") && !_adsController.isPremium.value) {
      showRewardedAdAdMob();
    } else if (adsType.contains("1") && !_adsController.isPremium.value) {
      showFbRewardedAd();
    } else if (adsType.contains("2") && !_adsController.isPremium.value) {
      showUnityRewardedAd();
    } else if (adsType.contains("3") && !_adsController.isPremium.value) {
      showIronSourceRewardedAd();
    }
  }
}

class IronBannerAdListener extends LevelPlayBannerAdViewListener {
  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {}

  @override
  void onAdCollapsed(LevelPlayAdInfo adInfo) {}

  @override
  void onAdDisplayFailed(LevelPlayAdInfo adInfo, LevelPlayAdError error) {}

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {}

  @override
  void onAdExpanded(LevelPlayAdInfo adInfo) {}

  @override
  void onAdLeftApplication(LevelPlayAdInfo adInfo) {}

  @override
  void onAdLoadFailed(LevelPlayAdError error) {}

  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) {
    AdsHelper()._adsController.isBannerLoaded.value = true;
  }
}

class IronInterAdListener extends IronSourceInitializationListener {
  @override
  void onInitializationComplete() {}
}
