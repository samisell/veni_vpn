import 'dart:convert';

AdsModel adsModelFromJson(String str) => AdsModel.fromJson(json.decode(str));

String adsModelToJson(AdsModel data) => json.encode(data.toJson());

class AdsModel {
  final String? status;
  final String? message;
  final Data? data;

  AdsModel({
    this.status,
    this.message,
    this.data,
  });

  factory AdsModel.fromJson(Map<String, dynamic> json) => AdsModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final int? id;
  final dynamic admobAndroidPublisherAccountId;
  final String? admobAndroidBannerAdUnitId;
  final String? admobAndroidInterstitialAdUnitId;
  final String? admobAndroidNativeAdUnitId;
  final String? admobAndroidRewardAdUnitId;
  final String? admobAndroidAppOpenAdUnitId;
  final dynamic admobIosBannerAdUnitId;
  final dynamic admobIosInterstitialAdUnitId;
  final dynamic admobIosNativeAdUnitId;
  final dynamic admobIosRewardAdUnitId;
  final dynamic admobIosAppOpenAdUnitId;
  final dynamic facebookAndroidBannerAdUnitId;
  final dynamic facebookAndroidInterstitialAdUnitId;
  final dynamic facebookAndroidNativeAdUnitId;
  final dynamic facebookAndroidRewardAdUnitId;
  final dynamic facebookIosBannerAdUnitId;
  final dynamic facebookIosInterstitialAdUnitId;
  final dynamic facebookIosNativeAdUnitId;
  final dynamic facebookIosRewardAdUnitId;
  final dynamic unityGameId;
  final dynamic unityBannerAdPlacementId;
  final dynamic unityInterstitialAdPlacementId;
  final dynamic ironsourceAppKey;
  final dynamic interstitialAdInterval;
  final dynamic nativeAdIndex;
  final String? adsType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Data({
    this.id,
    this.admobAndroidPublisherAccountId,
    this.admobAndroidBannerAdUnitId,
    this.admobAndroidInterstitialAdUnitId,
    this.admobAndroidNativeAdUnitId,
    this.admobAndroidRewardAdUnitId,
    this.admobAndroidAppOpenAdUnitId,
    this.admobIosBannerAdUnitId,
    this.admobIosInterstitialAdUnitId,
    this.admobIosNativeAdUnitId,
    this.admobIosRewardAdUnitId,
    this.admobIosAppOpenAdUnitId,
    this.facebookAndroidBannerAdUnitId,
    this.facebookAndroidInterstitialAdUnitId,
    this.facebookAndroidNativeAdUnitId,
    this.facebookAndroidRewardAdUnitId,
    this.facebookIosBannerAdUnitId,
    this.facebookIosInterstitialAdUnitId,
    this.facebookIosNativeAdUnitId,
    this.facebookIosRewardAdUnitId,
    this.unityGameId,
    this.unityBannerAdPlacementId,
    this.unityInterstitialAdPlacementId,
    this.ironsourceAppKey,
    this.interstitialAdInterval,
    this.nativeAdIndex,
    this.adsType,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    admobAndroidPublisherAccountId: json["admob_android_publisher_account_id"],
    admobAndroidBannerAdUnitId: json["admob_android_banner_ad_unit_id"],
    admobAndroidInterstitialAdUnitId: json["admob_android_interstitial_ad_unit_id"],
    admobAndroidNativeAdUnitId: json["admob_android_native_ad_unit_id"],
    admobAndroidRewardAdUnitId: json["admob_android_reward_ad_unit_id"],
    admobAndroidAppOpenAdUnitId: json["admob_android_app_open_ad_unit_id"],
    admobIosBannerAdUnitId: json["admob_ios_banner_ad_unit_id"],
    admobIosInterstitialAdUnitId: json["admob_ios_interstitial_ad_unit_id"],
    admobIosNativeAdUnitId: json["admob_ios_native_ad_unit_id"],
    admobIosRewardAdUnitId: json["admob_ios_reward_ad_unit_id"],
    admobIosAppOpenAdUnitId: json["admob_ios_app_open_ad_unit_id"],
    facebookAndroidBannerAdUnitId: json["facebook_android_banner_ad_unit_id"],
    facebookAndroidInterstitialAdUnitId: json["facebook_android_interstitial_ad_unit_id"],
    facebookAndroidNativeAdUnitId: json["facebook_android_native_ad_unit_id"],
    facebookAndroidRewardAdUnitId: json["facebook_android_reward_ad_unit_id"],
    facebookIosBannerAdUnitId: json["facebook_ios_banner_ad_unit_id"],
    facebookIosInterstitialAdUnitId: json["facebook_ios_interstitial_ad_unit_id"],
    facebookIosNativeAdUnitId: json["facebook_ios_native_ad_unit_id"],
    facebookIosRewardAdUnitId: json["facebook_ios_reward_ad_unit_id"],
    unityGameId: json["unity_game_id"],
    unityBannerAdPlacementId: json["unity_banner_ad_placement_id"],
    unityInterstitialAdPlacementId: json["unity_interstitial_ad_placement_id"],
    ironsourceAppKey: json["ironsource_app_key"],
    interstitialAdInterval: json["interstitial_ad_interval"],
    nativeAdIndex: json["native_ad_index"],
    adsType: json["ads_type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "admob_android_publisher_account_id": admobAndroidPublisherAccountId,
    "admob_android_banner_ad_unit_id": admobAndroidBannerAdUnitId,
    "admob_android_interstitial_ad_unit_id": admobAndroidInterstitialAdUnitId,
    "admob_android_native_ad_unit_id": admobAndroidNativeAdUnitId,
    "admob_android_reward_ad_unit_id": admobAndroidRewardAdUnitId,
    "admob_android_app_open_ad_unit_id": admobAndroidAppOpenAdUnitId,
    "admob_ios_banner_ad_unit_id": admobIosBannerAdUnitId,
    "admob_ios_interstitial_ad_unit_id": admobIosInterstitialAdUnitId,
    "admob_ios_native_ad_unit_id": admobIosNativeAdUnitId,
    "admob_ios_reward_ad_unit_id": admobIosRewardAdUnitId,
    "admob_ios_app_open_ad_unit_id": admobIosAppOpenAdUnitId,
    "facebook_android_banner_ad_unit_id": facebookAndroidBannerAdUnitId,
    "facebook_android_interstitial_ad_unit_id": facebookAndroidInterstitialAdUnitId,
    "facebook_android_native_ad_unit_id": facebookAndroidNativeAdUnitId,
    "facebook_android_reward_ad_unit_id": facebookAndroidRewardAdUnitId,
    "facebook_ios_banner_ad_unit_id": facebookIosBannerAdUnitId,
    "facebook_ios_interstitial_ad_unit_id": facebookIosInterstitialAdUnitId,
    "facebook_ios_native_ad_unit_id": facebookIosNativeAdUnitId,
    "facebook_ios_reward_ad_unit_id": facebookIosRewardAdUnitId,
    "unity_game_id": unityGameId,
    "unity_banner_ad_placement_id": unityBannerAdPlacementId,
    "unity_interstitial_ad_placement_id": unityInterstitialAdPlacementId,
    "ironsource_app_key": ironsourceAppKey,
    "interstitial_ad_interval": interstitialAdInterval,
    "native_ad_index": nativeAdIndex,
    "ads_type": adsType,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}