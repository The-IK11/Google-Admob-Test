import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_admob/presentation/widgets/adbutton_widget.dart';
import 'package:google_admob/presentation/widgets/banner_ad_widget.dart';
import 'package:google_admob/presentation/widgets/interstitial_ad_manager.dart';

class AllButtonScreen extends StatefulWidget {
  const AllButtonScreen({super.key});

  @override
  State<AllButtonScreen> createState() => _AllButtonScreenState();
}

class _AllButtonScreenState extends State<AllButtonScreen>
    with SingleTickerProviderStateMixin {
  bool isLoad = false;
  bool isBannerAd = false;
  int coinCount = 0;
  late AnimationController _floatingAnimationController;
  late Animation<Offset> _floatingAnimation;

  InterstitialAdManger interstitialAdManger = InterstitialAdManger.instance();

  @override
  void initState() {
    interstitialAdManger.loadInterstitialAd(dotenv.env['INTERSTITIAL_UNIT_ID'] ?? '');
    
    // Setup floating animation
    _floatingAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatingAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -15),
    ).animate(
      CurvedAnimation(parent: _floatingAnimationController, curve: Curves.easeInOut),
    );
    
    super.initState();
  }

  @override
  void dispose() {
    _floatingAnimationController.dispose();
    interstitialAdManger.disposeAd();
    super.dispose();
  }

  void onButtonPressed() {
    // Show loading dialog if ad is not loaded yet
    if (!interstitialAdManger.isAdLoaded) {
      _showLoadingDialog();
      // Load the ad
      interstitialAdManger.loadInterstitialAd(dotenv.env['INTERSTITIAL_UNIT_ID'] ?? '');
    } else {
      // Ad is already loaded, show it
      interstitialAdManger.showAd();
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6200EE)),
                        strokeWidth: 4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Loading Ad...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please wait a moment',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google AdMob',style: TextStyle(color: Colors.white),),
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
                //Admob logo

Center(
                  child: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/Logo_de_Google_AdMob.png/640px-Logo_de_Google_AdMob.png',
                    loadingBuilder: (context, child, loadingProgress) => loadingProgress == null
                        ? child
                        : const SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(),
                          ),
                    height: 80,
                    width: MediaQuery.of(context).size.width * 0.9,
                    fit: BoxFit.cover,
                  
                  ),
                ),

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

               // Earned coin by rewarded ad
               Container(
                 margin: const EdgeInsets.symmetric(vertical: 20),
                 padding: const EdgeInsets.all(20),
                 decoration: BoxDecoration(
                   gradient: LinearGradient(
                     colors: [
                       const Color(0xFFFFD700).withOpacity(0.9),
                       const Color(0xFFFFA500).withOpacity(0.9),
                     ],
                     begin: Alignment.topLeft,
                     end: Alignment.bottomRight,
                   ),
                   borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                     BoxShadow(
                       color: const Color(0xFFFFD700).withOpacity(0.5),
                       blurRadius: 15,
                       offset: const Offset(0, 8),
                     ),
                   ],
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     // Coin Icon
                     Container(
                       padding: const EdgeInsets.all(12),
                       decoration: BoxDecoration(
                         color: Colors.white.withOpacity(0.3),
                         borderRadius: BorderRadius.circular(12),
                       ),
                       child: const Icon(
                         Icons.monetization_on,
                         color: Colors.white,
                         size: 40,
                       ),
                     ),
                     const SizedBox(width: 20),
                     // Coin Count with Floating Animation
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           'Total Coins',
                           style: TextStyle(
                             fontSize: 12,
                             fontWeight: FontWeight.w500,
                             color: Colors.white.withOpacity(0.9),
                           ),
                         ),
                         const SizedBox(height: 4),
                         // Floating Coin Count
                         SlideTransition(
                           position: _floatingAnimation,
                           child: Text(
                             '$coinCount',
                             style: const TextStyle(
                               fontSize: 32,
                               fontWeight: FontWeight.bold,
                               color: Colors.white,
                             ),
                           ),
                         ),
                       ],
                     ),
                     const Spacer(),
                     // Add Coin Button (for testing)
                     GestureDetector(
                       onTap: () {
                         setState(() {
                           coinCount += 10;
                         });
                       },
                       child: Container(
                         padding: const EdgeInsets.symmetric(
                           horizontal: 16,
                           vertical: 10,
                         ),
                         decoration: BoxDecoration(
                           color: Colors.white.withOpacity(0.2),
                           borderRadius: BorderRadius.circular(12),
                           border: Border.all(
                             color: Colors.white.withOpacity(0.5),
                             width: 2,
                           ),
                         ),
                         child: const Text(
                           '+10',
                           style: TextStyle(
                             fontSize: 14,
                             fontWeight: FontWeight.bold,
                             color: Colors.white,
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),

                const Spacer(),                // Footer
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
