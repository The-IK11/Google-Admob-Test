import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

//Intersitial Ad Manager and Rewarded Ad Manager have similar structure
class RewardAdManager {


  static final RewardAdManager _instance = RewardAdManager._internal();
  factory RewardAdManager.instance() {
    return _instance;
  }
  RewardAdManager._internal();
  
RewardedAd?_rewardedAd;
  bool isAdLoaded = false;
  late String _unitId;

  void setUnitId(String unitId) {
    _unitId = unitId;
  }

  void loadRewardedAd(String unitId) {
    _unitId = unitId;

    if (unitId.isEmpty) {
      debugPrint('ERROR: REWARDED_UNIT_ID is empty');
      return;
    }

    debugPrint('🔍 Loading Rewarded Ad with Unit ID: $unitId');

    RewardedAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          isAdLoaded = true;
          debugPrint('✓ Rewarded Ad loaded successfully');

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (RewardedAd ad) =>
                debugPrint('✓ Ad showed full screen'),
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              debugPrint('✓ Ad dismissed full screen');
              ad.dispose();
              isAdLoaded = false;
              loadRewardedAd(_unitId);
            },
            onAdFailedToShowFullScreenContent:
                (RewardedAd ad, AdError error) {
              debugPrint('✗ Ad failed to show full screen: $error');
              ad.dispose();
              isAdLoaded = false;
              loadRewardedAd(_unitId);
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          isAdLoaded = false;
          debugPrint('✗ Rewarded Ad failed to load: $error');
        },
      ),
    );
  }

  void showRewardedAd({required VoidCallback onUserEarnedReward}) {
    if (_rewardedAd == null) {
      debugPrint(' ERROR: Rewarded Ad is not loaded yet');
      return;
    }

    _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      debugPrint('✓ User earned reward: ${reward.amount} ${reward.type}');
      onUserEarnedReward();
      isAdLoaded=false;
    });

  }

}