import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';

class Header extends StatelessWidget {
  final VoidCallback? onFeaturesTap;
  final VoidCallback? onHowItWorksTap;
  final VoidCallback? onSupportTap;

  const Header({
    super.key,
    this.onFeaturesTap,
    this.onHowItWorksTap,
    this.onSupportTap,
  });

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://skill-lynk.web.app/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/'),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.link, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  'SkillLynk',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (!isMobile) ...[
            _NavLink(label: 'Features', onTap: onFeaturesTap ?? () {}),
            _NavLink(label: 'How it Works', onTap: onHowItWorksTap ?? () {}),
            _NavLink(label: 'Support', onTap: onSupportTap ?? () {}),
            const SizedBox(width: 24),
            ElevatedButton(
              onPressed: _launchUrl,
              child: const Text('Get Started'),
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
