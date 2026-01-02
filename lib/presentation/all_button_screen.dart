import 'package:flutter/material.dart';

class AllButtonScreen extends StatelessWidget {
  const AllButtonScreen({super.key});

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
                _AdButton(
                  title: 'Banner Ad',
                  subtitle: 'Rectangular ad at the bottom',
                  icon: Icons.image_outlined,
                  color: const Color(0xFF6200EE),
                  onPressed: () {
                    _showAdDialog(context, 'Banner Ad',
                        'Banner ads appear at the bottom of the screen');
                  },
                ),
                const SizedBox(height: 20),

                // Interstitial Ad Button
                _AdButton(
                  title: 'Interstitial Ad',
                  subtitle: 'Full-screen ads between transitions',
                  icon: Icons.fullscreen_outlined,
                  color: const Color(0xFF03DAC6),
                  onPressed: () {
                    _showAdDialog(context, 'Interstitial Ad',
                        'Full-screen ads that appear between screen transitions');
                  },
                ),
                const SizedBox(height: 20),

                // Rewarded Ad Button
                _AdButton(
                  title: 'Rewarded Ad',
                  subtitle: 'Users earn rewards after watching',
                  icon: Icons.card_giftcard_outlined,
                  color: const Color(0xFFFF6D00),
                  onPressed: () {
                    _showAdDialog(context, 'Rewarded Ad',
                        'Users watch an ad and receive in-app rewards');
                  },
                ),

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

class _AdButton extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _AdButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  State<_AdButton> createState() => _AdButtonState();
}

class _AdButtonState extends State<_AdButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.color,
              widget.color.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(_isPressed ? 0.3 : 0.5),
              blurRadius: _isPressed ? 8 : 12,
              offset: Offset(0, _isPressed ? 2 : 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.7),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
