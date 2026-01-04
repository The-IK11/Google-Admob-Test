import 'dart:io';

class AdHelper {
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ANDROID_INTERSTITIAL_AD_UNIT_ID';
    } else if (Platform.isIOS) {
      return 'IOS_INTERSTITIAL_AD_UNIT_ID';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
