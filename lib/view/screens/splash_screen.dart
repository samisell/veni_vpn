import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../ads/open_ad_manager.dart';
import '../../ads/ads_helper.dart';
import '../../model/ads_model.dart';
import '../../model/settings_model.dart';
import '../../utils/app_layout.dart';
import '../../utils/my_helper.dart';
import 'home/home_screen.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  GetStorage sharedPref = GetStorage();

  Future<void> getAdsData() async {
    AdsModel? adsModel;
    try {
      final response = await http
          .get(Uri.parse(MyHelper.baseUrl + MyHelper.advertisementUrl));
      if (response.statusCode == 200) {
        adsModel = adsModelFromJson(response.body);
        sharedPref.write(MyHelper.adsType, adsModel.data?.adsType ?? '');
        sharedPref.write(MyHelper.bannerAdsAndroid,
            adsModel.data?.admobAndroidBannerAdUnitId ?? '');
        sharedPref.write(MyHelper.interAdsAndroid,
            adsModel.data?.admobAndroidInterstitialAdUnitId ?? '');
        sharedPref.write(MyHelper.nativeAdsAndroid,
            adsModel.data?.admobAndroidNativeAdUnitId ?? '');
        sharedPref.write(MyHelper.rewardAdsAndroid,
            adsModel.data?.admobAndroidRewardAdUnitId ?? '');
        sharedPref.write(MyHelper.openAdsAndroid,
            adsModel.data?.admobAndroidAppOpenAdUnitId ?? '');

        sharedPref.write(MyHelper.interAdsIos,
            adsModel.data?.admobIosInterstitialAdUnitId ?? '');
        sharedPref.write(
            MyHelper.bannerAdsIos, adsModel.data?.admobIosBannerAdUnitId ?? '');
        sharedPref.write(
            MyHelper.openAdsIOS, adsModel.data?.admobIosAppOpenAdUnitId ?? '');

        sharedPref.write(
            MyHelper.unityAdsAppId, adsModel.data?.unityGameId ?? '');
        sharedPref.write(MyHelper.unityAdsInterAndroid,
            adsModel.data?.unityInterstitialAdPlacementId ?? '');
        sharedPref.write(MyHelper.unityAdsBannerAndroid,
            adsModel.data?.unityBannerAdPlacementId ?? '');

        sharedPref.write(MyHelper.unityAdsInterIos, 'Interstitial_Ios');
        sharedPref.write(MyHelper.unityAdsBannerIos, 'Banner_Ios');

        sharedPref.write(
            MyHelper.ironAdsAppId, adsModel.data?.ironsourceAppKey ?? '');

        sharedPref.write(MyHelper.fbBannerAdsAndroid,
            adsModel.data?.facebookAndroidBannerAdUnitId ?? '');
        sharedPref.write(MyHelper.fbInterAdsAndroid,
            adsModel.data?.facebookAndroidInterstitialAdUnitId ?? '');
        sharedPref.write(MyHelper.fbNativeAdsAndroid,
            adsModel.data?.facebookAndroidNativeAdUnitId ?? '');
        sharedPref.write(MyHelper.fbRewardAdsAndroid,
            adsModel.data?.facebookAndroidRewardAdUnitId ?? '');

        sharedPref.write(MyHelper.fbBannerAdsIos,
            adsModel.data?.facebookIosBannerAdUnitId ?? '');
        sharedPref.write(MyHelper.fbInterAdsIos,
            adsModel.data?.facebookIosInterstitialAdUnitId ?? '');
        sharedPref.write(MyHelper.fbNativeAdsIos,
            adsModel.data?.facebookIosNativeAdUnitId ?? '');
        sharedPref.write(MyHelper.fbRewardAdsIos,
            adsModel.data?.facebookIosRewardAdUnitId ?? '');

        sharedPref.write(MyHelper.adsInterVal,
            int.parse(adsModel.data?.interstitialAdInterval ?? '0'));

        AdsHelper adsService = AdsHelper();
        adsService.initialization();

        appOpenAdManager.loadAd();
      }
    } catch (e) {
      print('___ $e');
    }
  }

  Future<void> getSettingsData() async {
    try {
      final response =
          await http.get(Uri.parse(MyHelper.baseUrl + MyHelper.settingsUrl));
      if (response.statusCode == 200) {
        SettingsModel settings = settingsModelFromJson(response.body);

        sharedPref.write(
            MyHelper.termsAndCondition, settings.data!.termsAndConditionsUrl);
        sharedPref.write(
            MyHelper.privacyPolicy, settings.data!.privacyPolicyUrl);
        sharedPref.write(MyHelper.contactUrl, settings.data!.contactUsUrl);
        sharedPref.write(MyHelper.faqUrl, settings.data!.faqUrl);
      }
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    getAdsData();
    getSettingsData();
  }

  @override
  Widget build(BuildContext context) {
    AppLayout.screenPortrait1();
    Future.delayed(const Duration(seconds: 2), () {
      if (AppOpenAdManager.isLoaded) {
        appOpenAdManager.showAdIfAvailable();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
    return Scaffold(
      body: Image.asset(
        'assets/images/splash.webp',
        fit: BoxFit.fill,
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
