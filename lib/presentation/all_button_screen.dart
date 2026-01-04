import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_admob/presentation/widgets/adbutton_widget.dart';
import 'package:google_admob/presentation/widgets/banner_ad_widget.dart';
import 'package:google_admob/presentation/widgets/interstitial_ad_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AllButtonScreen extends StatefulWidget {
  const AllButtonScreen({super.key});

  @override
  State<AllButtonScreen> createState() => _AllButtonScreenState();
}

class _AllButtonScreenState extends State<AllButtonScreen> {
  bool isBannerAd = false;
  

  InterstitialAdManger interstitialAdManger = InterstitialAdManger.instance();
@override
void initState(){
  interstitialAdManger.loadInterstitialAd(dotenv.env['INTERSTITIAL_UNIT_ID'] ?? '');
  super.initState();
}

@override
void dispose(){
  interstitialAdManger.disposeAd();
  super.dispose();
}

void onButtonPressed(){
  interstitialAdManger.showAd();

  // Additional logic can be added here if needed
  // for example, loading a new ad after showing the current one.
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google AdMob'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF6200EE),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF6200EE).withOpacity(0.1),
              const Color(0xFF03DAC6).withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Text
                const SizedBox(height: 20),
                Text(
                  'Choose Ad Type',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF6200EE),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Select the type of advertisement you want to display',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),

                // Banner Ad Button
                AdButton(
                  title: 'Banner Ad',
                  subtitle: 'Rectangular ad at the bottom',
                  icon: Icons.image_outlined,
                  color: const Color(0xFF6200EE),
                  onPressed: () {
                    // _showAdDialog(context, 'Banner Ad',
                    //     'Banner ads appear at the bottom of the screen');
                    setState(() {
                      isBannerAd = !isBannerAd;
                    });

                  },
                ),
                const SizedBox(height: 20),

                // Interstitial Ad Button
                AdButton(
                  title: 'Interstitial Ad',
                  subtitle: 'Full-screen ads between transitions',
                  icon: Icons.fullscreen_outlined,
                  color: const Color(0xFF03DAC6),
                  onPressed: onButtonPressed,
                ),
                const SizedBox(height: 20),

                // Rewarded Ad Button
                AdButton(
                  title: 'Rewarded Ad',
                  subtitle: 'Users earn rewards after watching',
                  icon: Icons.card_giftcard_outlined,
                  color: const Color(0xFFFF6D00),
                  onPressed: () {
                    _showAdDialog(context, 'Rewarded Ad',
                        'Users watch an ad and receive in-app rewards');
                  },
                ),

                const SizedBox(height: 20),
               if(isBannerAd)
                 BannerAdWidget(),
                const Spacer(),

                // Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '💡 Tip: Implement your ad logic in the respective button callbacks',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAdDialog(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
