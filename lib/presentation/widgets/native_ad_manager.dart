import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdManager {
  static final NativeAdManager _instance = NativeAdManager._internal();

  factory NativeAdManager.instance() {
    return _instance;
  }

  NativeAdManager._internal();

  NativeAd? _nativeAd;
  bool isAdLoaded = false;
  late String _unitId;

  void setUnitId(String unitId) {
    _unitId = unitId;
  }

  // Load the native ad
  void loadNativeAd(String unitId) {
    _unitId = unitId;

    if (unitId.isEmpty) {
      debugPrint('❌ ERROR: NATIVE_UNIT_ID is empty');
      return;
    }

    debugPrint('🔍 Loading Native Ad with Unit ID: $unitId');

    _nativeAd = NativeAd(
      adUnitId: unitId,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
      ),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('✓ Native Ad loaded successfully');
          isAdLoaded = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('✗ Native Ad failed to load: $error');
          ad.dispose();
          isAdLoaded = false;
        },
        onAdOpened: (Ad ad) => debugPrint('✓ Native Ad opened'),
        onAdClosed: (Ad ad) {
          debugPrint('✓ Native Ad closed');
          ad.dispose();
          isAdLoaded = false;
          // Reload after ad is closed
          loadNativeAd(_unitId);
        },
        onAdClicked: (Ad ad) => debugPrint('✓ Native Ad clicked'),
        onAdImpression: (Ad ad) => debugPrint('✓ Native Ad impression'),
      ),
    );

    _nativeAd?.load();
  }

  // Get the native ad
  NativeAd? getNativeAd() {
    return isAdLoaded ? _nativeAd : null;
  }

  // Check if ad is loaded
  bool get isLoaded => isAdLoaded;

  // Dispose the ad when not needed
  void disposeAd() {
    _nativeAd?.dispose();
    _nativeAd = null;
    isAdLoaded = false;
    debugPrint('✓ Native Ad disposed');
  }
}
