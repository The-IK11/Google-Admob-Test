import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManger {
  
  static final InterstitialAdManger _instance = InterstitialAdManger._internal();

  factory InterstitialAdManger.instance() {
    return _instance;
  }

  InterstitialAdManger._internal();

  InterstitialAd? _interstitialAd;
  bool isAdLoaded = false;
  late String _unitId;

  void setUnitId(String unitId) {
    _unitId = unitId;
  }

  // Load the ad under this _interstitialAd
  void loadInterstitialAd(String unitId) {
    _unitId = unitId;
    
    if (unitId.isEmpty) {
      debugPrint('ERROR: INTERSTITIAL_UNIT_ID is empty');
      return;
    }

    debugPrint('🔍 Loading Interstitial Ad with Unit ID: $unitId');

    InterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          isAdLoaded = true;
          debugPrint('✓ Interstitial Ad loaded successfully');

          // Set up full screen content callback
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (InterstitialAd ad) => 
              debugPrint('✓ Ad showed full screen'),
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              debugPrint('✓ Ad dismissed full screen');
              ad.dispose();
              isAdLoaded = false;
              // Reload the ad after it's dismissed
              loadInterstitialAd(_unitId);
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              debugPrint('✗ Ad failed to show full screen: $error');
              ad.dispose();
              isAdLoaded = false;
              // Reload the ad after failure
              loadInterstitialAd(_unitId);
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          isAdLoaded = false;
          debugPrint('✗ Interstitial Ad failed to load: $error');
        },
      ),
    );
  }

  // Show the ad if it is loaded
  void showAd() {
    if (isAdLoaded && _interstitialAd != null) {
      debugPrint('📺 Showing Interstitial Ad');
      _interstitialAd?.show();
    } else {
      debugPrint('⏳ Ad is not loaded yet, loading...');
      loadInterstitialAd(_unitId);
    }
  }

  // Dispose the ad when not needed
  void disposeAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    isAdLoaded = false;
    debugPrint('✓ Ad disposed');
  }
}