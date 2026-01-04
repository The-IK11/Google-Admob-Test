import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManger{
  
InterstitialAdManger.instance();

  InterstitialAd?_interstitialAd;
  bool isAdLoaded=false;


//load the ad under this _interstitialAd;

  void loadInterstitialAd(String unitId){

//add unit id for testing if it is release mode it will take automatically the real unit id 
    InterstitialAd.load(

     // adUnitId: kReleaseMode ? unitId : InterstitialAd.testAdUnitId, 
      adUnitId: unitId,
      request: const AdRequest(), 
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad){
          _interstitialAd=ad;
          isAdLoaded=true;

          //load this ad for full screen

          ad.fullScreenContentCallback=FullScreenContentCallback(
            onAdShowedFullScreenContent: (InterstitialAd ad)=>debugPrint('Ad showed full screen'),
            onAdDismissedFullScreenContent: (InterstitialAd ad){
              debugPrint('Ad dismissed full screen');
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error){
              debugPrint('Ad failed to show full screen: $error');
              ad.dispose();
            },
          );
        }, 
        onAdFailedToLoad: 
        (LoadAdError error){
isAdLoaded=false;
          debugPrint('InterstitialAd failed to load: $error');
        })
      
      );
 

}

// show the ad , if it is loaded
void showAd(){
  if(isAdLoaded && _interstitialAd!=null){
    _interstitialAd?.show();
  }else{
    debugPrint('Ad is not loaded yet');
  }
}

/// dispose the ad when not needed
void disposeAd(){
  _interstitialAd?.dispose();
  _interstitialAd = null;
  isAdLoaded = false;
}

}