import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    final unitId = dotenv.env['BANNER_UNIT_ID'] ?? '';
    print('🔍 Loading Banner Ad with Unit ID: $unitId');
    
    if (unitId.isEmpty) {
      print('❌ ERROR: BANNER_UNIT_ID not found in .env file');
      return;
    }
    
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: unitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('✓ Banner Ad loaded.');
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('✗ Banner Ad failed to load: $error');
          print('📋 Error Code: ${error.code}');
          print('📋 Error Domain: ${error.domain}');
          print('📋 Error Message: ${error.message}');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    );
    bannerAd?.load();
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (bannerAd == null || !_isBannerAdLoaded) {
      return Container(
        height: 50,
        color: Colors.grey[300],
        child: const Center(
          child: Text(
            'Banner Ad Loading...',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
      );
    }

    return Container(
      height: bannerAd!.size.height.toDouble(),
      color: Colors.grey[200],
      child: AdWidget(ad: bannerAd!),
    );
  }
}