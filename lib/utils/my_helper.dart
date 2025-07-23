class MyHelper {
  //base url
  static const String baseUrl = "https://vpn.venihost.com.ng/";
  static const String paymentBaseUrl = "https://sandbox.uddoktapay.com/";
  static const String vpnExtensionIdentifier =
      "com.venihost.borderless .VPNExtensions";
  static const String appname = "My VPN";

  // Flutterwave Configuration
  static const String flutterwavePublicKey = "FLWPUBK_TEST-SANDBOXDEMOKEY-X"; // Replace with your actual public key
  static const String flutterwaveSecretKey = "FLWSECK_TEST-SANDBOXDEMOKEY-X"; // Replace with your actual secret key
  static const bool flutterwaveIsTestMode = true; // Set to false for production

  // Exchange rate (update as needed)
  static const double usdToNgnRate = 1500.0;

  //from this below no need to change. If anything change app will not work
  static const String registerViaDeviceUrl = "api/device_register";
  static const String registerUrl = "api/user_registration";
  static const String loginUrl = "api/login";
  static const String logoutUrl = "api/logout";
  static const String sendOtpUrl = "api/send-otp";
  static const String verifyOtpUrl = "api/verify-otp";
  static const String changePasswordUrl = "api/password/reset";
  static const String userUrl = "api/user";
  static const String updateProfile = "api/user/update";
  static const String serverUrl = "api/servers";
  static const String advertisementUrl = "api/advertisement";
  static const String storeToken = "api/devices/store-token";
  static const String settingsUrl = "api/app-settings";
  static const String packageUrl = "api/pricings";

  static const String createPaymentUrl = "api/checkout-v2";
  static const String verifyPaymentUrl = "api/verify-payment";

  static const String savePaymentInfoUrl = "api/package-details/save";

  // Flutterwave endpoints
  static const String flutterwavePaymentUrl = "api/flutterwave-payment";

  //local storage
  static const String bToken = "bearer_token";
  static const String userName = "user_name";
  static const String userId = "user_id";
  static const String loginMode = "login_mode";
  static const String userEmail = "user_email";
  static const String expiaryDate = "expiary_date";
  static const String isAccountPremium = "is_account_premium";

  //ads
  static const String adsType = "adsType";

  static const String bannerAdsAndroid = "bannerAdsAndroid";
  static const String interAdsAndroid = "interAdsAndroid";
  static const String nativeAdsAndroid = "nativeAdsAndroid";
  static const String rewardAdsAndroid = "rewardAdsAndroid";
  static const String openAdsAndroid = "openAdsAndroid";


  static const String bannerAdsIos = "bannerAdsIos";
  static const String interAdsIos = "interAdsIos";
  static const String openAdsIOS = "interAdsIos";
  static const String nativeAdsIos = "nativeAdsIos";
  static const String rewardAdsIos = "rewardAdsIos";

  static const String unityAdsAppId = "unityAdsAppId";
  static const String unityAdsInterAndroid = "unityAdsInterAndroid";
  static const String unityAdsBannerAndroid = "unityAdsBannerAndroid";
  static const String unityAdsInterIos = "unityAdsInterIos";
  static const String unityAdsBannerIos = "unityAdsBannerIos";

  static const String ironAdsAppId = "ironAdsAppId";

  static const String fbBannerAdsAndroid = "fbBannerAdsAndroid";
  static const String fbInterAdsAndroid = "fbInterAdsAndroid";
  static const String fbNativeAdsAndroid = "fbNativeAdsAndroid";
  static const String fbRewardAdsAndroid = "fbRewardAdsAndroid";

  static const String fbBannerAdsIos = "fbBannerAdsIos";
  static const String fbInterAdsIos = "fbInterAdsIos";
  static const String fbNativeAdsIos = "fbNativeAdsIos";
  static const String fbRewardAdsIos = "fbRewardAdsIos";

  static const String adsInterVal = "adsInterVal";
  static const String saveAdsInterval = "save_adsInterVal";
  static const String token = 'user_token';

  //settings
  static const String privacyPolicy = "privacy_policy";
  static const String termsAndCondition = "terms_condition";
  static const String contactUrl = "contract_url";
  static const String faqUrl = "faq_url";

  //settings
  static const String autoConnect = "auto_connect";
  static const String saveLastServer = "save_last_server";
  static const String selectedServer = "selected_server";
  static const String notification = "notification";
  static const String removeAds = "removeAds";

  static const String DISMISS = "dismiss";
  static const String FAILED = "failed";

  // Helper methods for currency conversion
  static double convertUsdToNgn(double usdAmount) {
    return usdAmount * usdToNgnRate;
  }

  static String formatNairaAmount(double amount) {
    return "₦${amount.toStringAsFixed(0)}";
  }
}
